#!/usr/bin/env python
from __future__ import print_function

import sys
import argparse

from lxml import etree

NS = {'x': 'http://www.w3.org/1999/xhtml',
      'mml':'http://www.w3.org/1998/Math/MathML'}

body_xpath = etree.XPath('//x:body', namespaces=NS)

math_xpath = etree.XPath("//mml:math", namespaces=NS)


def main(html_in, html_out=sys.stdout):
    """Extract math nodes from book html file"""

    html = etree.parse(html_in)

    body = body_xpath(html)[0]

    math = math_xpath(body)

    body.clear()

    for m in math:
        m.tail = None
        body.append(m)

    print(etree.tostring(html), file=html_out)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Extract only math nodes from book html file")
    parser.add_argument("html_in",
                        type=argparse.FileType('r'),
                        help="assembled fullbook HTML file")
    parser.add_argument("html_out", nargs="?",
                        type=argparse.FileType('w'),
                        help="math-only HTML file output (default stdout)",
                        default=sys.stdout)
    args = parser.parse_args()
    main(args.html_in, args.html_out)
