import sys
import json

from lxml import etree
from cnxepub.html_parsers import DocumentMetadataParser

baked_xhtml_file, baked_metdata_file, book_uuid = sys.argv[1:4]

def get_legacy_id_from_uri(uri):
    if not uri.startswith('col', 0, 3): return None
    legacy_id, version = uri.split('@')
    return legacy_id

def capture_book_metadata():

    with open(baked_metdata_file, "r") as baked_json:
        baked_metadata = json.load(baked_json)
    
    with open(baked_xhtml_file, "r") as baked_xhtml:
        html = etree.parse(baked_xhtml)
        metadata = DocumentMetadataParser(html)

        required_metadata = ('title', 'license_url')
        for required_data in required_metadata:
            if getattr(metadata, required_data) is None:
                raise ValueError("A value for '{}' could not be found.")
        
        legacy_id = get_legacy_id_from_uri(metadata.cnx_archive_uri)
        baked_book_json = {
            "title": metadata.title,
            "license": {
                "url": metadata.license_url
            },
            "legacy_id": legacy_id,
        }

        baked_metadata[book_uuid] = baked_book_json

    with open(baked_metdata_file, "w") as json_out:
        json.dump(
            baked_metadata,
            json_out
        )
        json_out.close()

if __name__ == "__main__":
    capture_book_metadata()
