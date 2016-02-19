#!/usr/bin/env python
import sys
import argparse
import tempfile

import fullbook
import extractmath


def main(code, mathjax_version=None, html_out=sys.stdout):
    """Generate book HTML with math only."""
    tmp = tempfile.TemporaryFile()
    fullbook.main(code, tmp, mathjax_version)
    tmp.seek(0, 0)
    extractmath.main(tmp, html_out)
    tmp.close()


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Assemble complete book "
                                                 "as single HTML file")
    parser.add_argument("bookid", help="Identifier of book: "
                        "<uuid|shortId>[@ver]")
    parser.add_argument("mathjax_version", nargs="?",
                        help="MathJax version",
                        default=None)
    parser.add_argument("html_out", nargs="?",
                        type=argparse.FileType('w'),
                        help="assembled math-only HTML file output (default stdout)",
                        default=sys.stdout)
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Send debugging info to stderr')
    parser.add_argument('-s', '--subset-chapters', dest='numchapters',
                        type=int, const=2, nargs='?', metavar='num_chapters',
                        help="Create subset of complete book "
                        "(default 2 chapters plus extras)")
    args = parser.parse_args()
    fullbook.verbose = args.verbose
    fullbook.args = args
    main(args.bookid, args.mathjax_version, args.html_out)
