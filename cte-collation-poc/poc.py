#!/usr/bin/env python
from __future__ import print_function

import sys
import argparse

import tinycss
import cssselect
from cssselect import HTMLTranslator
from lxml import etree
import copy


def debug(*args, **kwargs):
    if verbose:
        print(*args, file=sys.stderr, **kwargs)


def main(css_in, html_in=sys.stdin, html_out=sys.stdout):
    """Process the given HTML file stream with the css stream."""

    html_parser = etree.HTMLParser()
    css_parser = tinycss.make_parser()

    style_sheet = css_parser.parse_stylesheet_file(css_in)
    debug(style_sheet)

    html_doc = etree.HTML(html_in.read(), html_parser)
    debug(html_doc)

    # Process CSS stylesheet -
    #  find all the targets ( #div w/ pending()
    #    TODO ignoring nesting for now
    #  find all the actions (move_to/copy_to)
    #  find everything that needs numbering
    #    TODO do we want explicit numbering only, or have a default
    #    and only describe deviations from that? (perhaps mechanism
    #    should be "define them all" and implementation will have a
    #    default.less @import()ed at the top, so the usual use case
    #    will be to only override.
    #  determine order/number of passes for numbering (count before
    #    or after move, etc.

    action_targets = {}
    pending = {}
    content = []
    for rule in style_sheet.rules:
        for decl in rule.declarations:
            if decl.name in ['move-to', 'copy-to']:
                action_targets[decl.value.as_css()] = {'rule': rule,
                                                       'type': decl.name}
            elif decl.name == 'content':
                if (decl.value[0].type == u'FUNCTION' and
                   decl.value[0].function_name == 'pending'):
                    pending[decl.value[0].content[0].value] = {'rule': rule}
                else:
                    content.append(rule)

    debug(action_targets.keys(), pending.keys())
    debug(content)

    # Validate targets and actions
    action_pending = (set(action_targets.keys()) - set(pending.keys()))
    pending_action = (set(pending.keys()) - set(action_targets.keys()))

    if (action_pending):
        print("Invalid CSS: more targets than pending: {}".
              format(','.join(action_pending)), file=sys.stderr)
        sys.exit(1)
    elif (pending_action):
        print("Invalid CSS: more pending than targets: {}".
              format(','.join(pending_action)), file=sys.stderr)
        sys.exit(1)

    debug('CSS parsed: {} targets'.format(len(pending)), file=sys.stderr)

    # Loop over actions, grab selectors, convert to xpaths, apply to HTML DOM
    # and extract content to copy/move

    for action, value in action_targets.items():
        xpath = etree.XPath(rule_to_xpath(value['rule']))
        debug('Target XPath:', xpath)
        nodes = xpath(html_doc)
        debug(nodes)
        action_targets[action]['nodes'] = nodes

    # Loop over pending targets, grab selectors, convert to xpaths, apply to
    # HTML DOM and extract target for copy/move.

    for target, value in pending.items():
        rule = value['rule']
        xpath = etree.XPath(rule_to_xpath(rule))
        debug('Pending XPath:', xpath)
        nodes = xpath(html_doc)
        debug(nodes)
        pending[target]['nodes'] = nodes

        element = rule_to_element(rule, action_targets[target])
        if element is not None:
            nodes[0].append(element)

    print(etree.tostring(html_doc), file=html_out)


def rule_to_xpath(rule):
    """Convert CSS rule selector to HTML xpath """
    s = cssselect.parse(rule.selector.as_css())
    #FIXME need to extend selector_to_xpath to handle custom
    # psuedo-selector, namely '::div'
    # esp. for any sort of nesting
    xpath = HTMLTranslator().selector_to_xpath(s[0])
    return xpath


def rule_to_element(rule, content):
    """Converts custom CSS selector and declartions to HTML element"""

    if rule.selector.as_css().endswith('::div'):
        elem = etree.Element('div')
        for decl in rule.declarations:
            if decl.name == 'class':
                elem.attrib['class'] = decl.value.as_css()
            elif decl.name == 'sort-by':
                sort_by_css(decl.value.as_css(), content['nodes'])

            elif decl.name == 'group-by':
                pass
                #FIXME group-by

    col_type = content['type']
    if col_type == 'move-to':
        for node in content['nodes']:
            elem.append(node)
    elif col_type == 'copy-to':
        for node in content['nodes']:
            elem.append(copy.deepcopy(node))

    return elem


def sort_by_css(css, nodes):
    """Sorts a list of nodes by the text value of the css selector"""

    xpath = etree.XPath(HTMLTranslator().css_to_xpath(css) + '/text()')
    #FIXME extend translator for ::text pseudo
    nodes.sort(key=xpath)

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Process raw HTML to cooked"
                                                 " (embedded numbering and"
                                                 " collation)")
    parser.add_argument("css_rules", help="CSS3 ruleset stylesheet recipe")
    parser.add_argument("html_in", nargs="?",
                        type=argparse.FileType('r'),
                        help="raw HTML file to cook (default stdin)",
                        default=sys.stdin)
    parser.add_argument("html_out", nargs="?",
                        type=argparse.FileType('w'),
                        help="cooked HTML file output (default stdout)",
                        default=sys.stdout)
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Send debugging info to stderr')
    args = parser.parse_args()
    verbose = args.verbose
    main(args.css_rules, args.html_in, args.html_out)
