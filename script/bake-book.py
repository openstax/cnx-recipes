import sys
import json

from lxml import etree
from cnxepub.html_parsers import DocumentMetadataParser
import pprint

# in_path: ./data/physics/collection.baked.xhtml
# out_path: ./data/physics/collection.baked-metadata.json
# book_json
#     {
#         "031da8d3-b525-429c-80cf-6c8ed997733a" : {
#             "abstract": '\n'
#              '        <div xmlns="http://www.w3.org/1999/xhtml" '
#              'xmlns:c="http://cnx.rice.edu/cnxml" '
#              'xmlns:md="http://cnx.rice.edu/mdml" '
#              'xmlns:qml="http://cnx.rice.edu/qml/1.0" '
#              'xmlns:mod="http://cnx.rice.edu/#moduleIds" '
#              'xmlns:bib="http://bibtexml.sf.net/" '
#              'xmlns:data="http://dev.w3.org/html5/spec/#custom" '
#              'xmlns:epub="http://www.idpf.org/2007/ops" '
#              'xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" '
#              'xmlns:dc="http://purl.org/dc/elements/1.1/" '
#              'xmlns:lrmi="http://lrmi.net/the-specification"/>\n'
#              '      \n'
#              '      ',
#             "legacy_id": "col11406",
#             "license": {'code": 'by',
#                         "name": 'Creative Commons Attribution License',
#                         "url": 'http://creativecommons.org/licenses/by/4.0/',
#                         "version": '4.0'},
#             "title": 'College Physics'
#             "tree": .....
#         }
#     }

in_path, out_path = sys.argv[1:3]

book_json = {}

def extract_legacy_id(uri):
    if not uri.startswith('col', 0, 3): return None
    legacy_id, version = uri.split('@')
    return legacy_id

with open(in_path, "r") as in_file:
    html = etree.parse(in_file)
    metadata = DocumentMetadataParser(html)
    book_json.update({'title' : metadata.title})
    book_json.update({'license': {
        'url' : metadata.license_url
        }
    })
    book_json.update({'legacy_id' : extract_legacy_id(metadata.cnx_archive_uri)})

    print(book_json)

with open(out_path, "w") as out_file:
    json.dump(json_data, out_file)

# tree = parse_navigation_html_to_tree(html, 'toc')
# this gives you ALMOST everything you are looking for, but not quite.
# pprint.pprint(tree)