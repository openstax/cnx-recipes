#!/usr/bin/env python
from __future__ import print_function

try:
    from html import escape  # python3
except ImportError:
    from cgi import escape  # python2
import sys
import argparse

import requests
from lxml import etree

ARCHIVEJS = 'http://archive.cnx.org/contents/{}.json'
ARCHIVEHTML = 'http://archive.cnx.org/contents/{}.html'
NS = {'x': 'http://www.w3.org/1999/xhtml'}
SCRIPT_WRAPPER = '<script '\
                 'src="https://cdn.mathjax.org/mathjax/{mathjax_version}/'\
                 'unpacked/MathJax.js?config=MML_HTMLorMML"> </script>'
HTMLWRAPPER = """<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<title>{title}</title>
<link href="styles.css" rel="stylesheet" type="text/css"/>
{script_tag}
</head>
</html>
"""

title_xpath = etree.XPath("./x:div[@data-type='document-title']",
                          namespaces=NS)

parts = ['page', 'chapter', 'unit', 'book', 'series']
partcount = {}.fromkeys(parts, 0)


def debug(*args, **kwargs):
    if verbose:
        print(*args, file=sys.stderr, **kwargs)


def main(code, html_out=sys.stdout, mathjax_version=None):
    """Generate complete book HTML."""

    res = requests.get(ARCHIVEJS.format(code))
    b_json = res.json()
    if mathjax_version:
        script_tag = SCRIPT_WRAPPER.format(mathjax_version=mathjax_version)
    else:
        script_tag = ''
    html = etree.fromstring(HTMLWRAPPER.format(
                            title=escape(b_json['title']).encode('utf-8'),
                            script_tag=script_tag))
    book_elem = etree.SubElement(html, 'body', attrib={'data-type': 'book'})
    title_elem = etree.SubElement(book_elem, 'div',
                                  attrib={'data-type': 'document-title'})
    id_and_version = '{}@{}'.format(b_json['id'], b_json['version'])
    link_elem = etree.SubElement(title_elem, 'a',
                                 attrib={'href': ARCHIVEHTML.format(
                                         id_and_version),
                                         'title': id_and_version})
    link_elem.text = b_json['title']
    partcount['book'] += 1

    html_nest(b_json['tree']['contents'], book_elem)

    debug(' '.join(['{}: {}'.format(name, partcount[name]) for name in parts]))
    print(etree.tostring(html), file=html_out)


def html_nest(tree, parent):
    """Recursively construct HTML nested div version of book tree."""
    for node in tree:
        div_elem = etree.SubElement(parent, 'div')
        if node['id'] != 'subcol' and 'contents' not in node:
            page_nodes(node['id'], div_elem)
            set_parent_type(div_elem, parent)

        if args.numchapters is None or partcount['chapter'] < args.numchapters:
            try:
                title_elem = title_xpath(div_elem)[0]
            except IndexError:
                title_elem = etree.Element('div',
                                           attrib={'data-type':
                                                   'document-title'})
                div_elem.insert(0, title_elem)

            title_elem.text = node['title']
            debug(node['title'])

            if 'contents' in node:
                html_nest(node['contents'], div_elem)


def set_parent_type(node, parent):
    if parent is not None and parent.tag != 'body':
        mytype = node.get('data-type')
        mytypeid = parts.index(mytype)
        if parent.get('data-type'):
            parenttype = parent.get('data-type')
            parenttypeid = parts.index(parenttype)
            if parenttypeid <= mytypeid:
                parent.set('data-type', parts[mytypeid + 1])
                partcount[parenttype] -= 1
                partcount[parts[mytypeid + 1]] += 1
        else:
            parent.set('data-type', parts[mytypeid + 1])
            partcount[parts[mytypeid + 1]] += 1

        set_parent_type(parent, parent.getparent())


def page_nodes(page_id, elem):
    """Fetch page return body wrapped in provided element."""

    debug(page_id)
    res = requests.get(ARCHIVEHTML.format(page_id))
    xpath = etree.XPath('//x:body', namespaces=NS)

    body = xpath(etree.fromstring(res.content))[0]

    elem.set('data-type', 'page')
    partcount['page'] += 1
    for c in body.iterchildren():
        elem.append(c)

    return elem


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Assemble complete book "
                                                 "as single HTML file")
    parser.add_argument("bookid", help="Identifier of book: "
                        "<uuid|shortId>[@ver]")
    parser.add_argument("html_out", nargs="?",
                        type=argparse.FileType('w'),
                        help="assembled HTML file output (default stdout)",
                        default=sys.stdout)
    parser.add_argument('-m', "--mathjax_version", const="latest",
                        metavar="mathjax_version", nargs="?",
                        help="Add script tag to use MathJax of given version")
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Send debugging info to stderr')
    parser.add_argument('-s', '--subset-chapters', dest='numchapters',
                        type=int, const=2, nargs='?', metavar='num_chapters',
                        help="Create subset of complete book "
                        "(default 2 chapters plus extras)")
    args = parser.parse_args()
    verbose = args.verbose
    mathjax_version = args.mathjax_version
    if mathjax_version:
        if not mathjax_version.endswith('latest'):
            mathjax_version += '-latest'
    main(args.bookid, args.html_out, mathjax_version)
