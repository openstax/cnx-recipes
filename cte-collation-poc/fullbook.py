#!/usr/bin/env python
from __future__ import print_function

import sys
import argparse

import requests
from lxml import etree

ARCHIVEJS = 'http://archive.cnx.org/contents/{}.json'
ARCHIVEHTML = 'http://archive.cnx.org/contents/{}.html'
NS = {'x': 'http://www.w3.org/1999/xhtml'}
HTMLWRAPPER = """<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>{title}</title>
<style href="styles.css" rel="stylsheet" type="text/css"/>
</head>
</html>
"""


def debug(*args, **kwargs):
    if verbose:
        print(*args, file=sys.stderr, **kwargs)


def main(code, html_out=sys.stdout):
    """Generate complete book HTML."""

    res = requests.get(ARCHIVEJS.format(code))
    b_json = res.json()
    html = etree.fromstring(HTMLWRAPPER.format(title=b_json['title']))
    book_elem = etree.SubElement(html, 'body', attrib={'data-type': 'book'})

    html_nest([b_json['tree']], book_elem)

    print(etree.tostring(html), file=html_out)


def html_nest(tree, root_element):
    """Recursively construct HTML nested div version of book tree."""
    for node in tree:
        div_elem = etree.SubElement(root_element, 'div')
        if node['id'] != 'subcol':
            page_nodes(node['id'], div_elem)
        title_xpath = etree.XPath("//x:div[@data-type='document-title']",
                                  namespaces=NS)
        try:
            title_elem = title_xpath(div_elem)[0]
        except IndexError:
            title_elem = etree.SubElement(div_elem, 'div',
                                          attrib={'data-type':
                                                  'document-title'})
        title_elem.text = node['title']
        debug(node['title'])
        if 'contents' in node:
            elem = etree.SubElement(div_elem, 'div')
            html_nest(node['contents'], elem)


def page_nodes(page_id, elem):
    """Fetch page return body wrapped in provided element."""

    debug(page_id)
    res = requests.get(ARCHIVEHTML.format(page_id))
    xpath = etree.XPath('//x:body', namespaces=NS)

    body = xpath(etree.fromstring(res.content))[0]

    elem.set('data-type', 'page')
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
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Send debugging info to stderr')
    args = parser.parse_args()
    verbose = args.verbose
    main(args.bookid, args.html_out)
