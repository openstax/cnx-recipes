import sys
import json
from pathlib import Path

from lxml import etree
from lxml.builder import ElementMaker, E

from cnxepub.collation import reconstitute
from cnxepub.html_parsers import HTML_DOCUMENT_NAMESPACES
from cnxepub.formatters import DocumentContentFormatter
from cnxepub.models import flatten_to, Document, model_to_tree
from cnxcommon.urlslug import generate_slug

# Based upon amend_tree_with_slugs from cnx-publishing
# (https://github.com/openstax/cnx-publishing/blob/master/cnxpublishing/utils.py#L64)
def amend_tree_with_slugs(tree, title_seq=[]):
    """Recursively walk through tree and add slug fields"""
    title_seq = title_seq + [tree['title']]
    tree['slug'] = generate_slug(*title_seq)
    if 'contents' in tree:
        for node in tree['contents']:
            amend_tree_with_slugs(node, title_seq)

def extract_slugs_from_tree(tree, data):
    """Given a tree with slugs create a flattened structure where slug data
    can be retrieved based upon id key
    """
    data.update({
        tree["id"]: tree["slug"]
    })
    if "contents" in tree:
        for node in tree["contents"]:
            extract_slugs_from_tree(node, data)

def extract_slugs_from_binder(binder):
    """Given a binder return a dictionary that allows caller to retrieve
    computed slugs using ident_hash values"""

    # NOTE: The returned tree has 'id' values which are based upon ident_hash
    # fields in the provided model
    tree = model_to_tree(binder)
    amend_tree_with_slugs(tree)
    slugs = {}
    extract_slugs_from_tree(tree, slugs)
    return slugs

def main():
    """Main function"""
    in_dir = Path(sys.argv[1]).resolve(strict=True)
    out_dir = (in_dir / "disassembled").resolve(strict=True)
    book_uuid = sys.argv[2]
    baked_file = (in_dir / "collection.baked.xhtml").resolve(strict=True)
    baked_metdata_file = (in_dir / "collection.baked-metadata.json").resolve(strict=True)

    with open(baked_file, "rb") as file:
        html_root = etree.parse(file)
        binder = reconstitute(file)

        # It's important that we generate slug metadata in parallel with disassemble
        # so that where ident_hash values are based upon potentially randomly
        # generated UUIDs we can still use them as unique keys in JSON outputs
        # without diverging
        slugs = extract_slugs_from_binder(binder)

    nav = html_root.xpath("//xhtml:nav", namespaces=HTML_DOCUMENT_NAMESPACES)[0]

    toc_maker = ElementMaker(namespace=None,
                             nsmap={None: "http://www.w3.org/1999/xhtml"})
    toc = toc_maker.html(E.head(E.title("Table of Contents")),
                         E.body(nav))

    with open(f"{out_dir}/collection.toc.xhtml", "wb") as out:
        out.write(etree.tostring(toc, encoding="utf8", pretty_print=True))

    with open(baked_metdata_file, "r") as baked_json:
        baked_metadata = json.load(baked_json)
        book_toc_metadata = baked_metadata[book_uuid]

    with open(f"{out_dir}/collection.toc-metadata.json", "w") as toc_json:
        json.dump(book_toc_metadata, toc_json)
        toc_json.close()

    for doc in flatten_to(binder, lambda d: isinstance(d, Document)):
        with open(f"{out_dir / doc.ident_hash}.xhtml", "wb") as out:
            out.write(bytes(DocumentContentFormatter(doc)))

        with open(f"{out_dir / doc.ident_hash}-metadata.json", "w") as json_out:
            # Incorporate metadata from disassemble step while setting defaults
            # for cases like composite pages which may not have metadata from
            # previous stages
            json_metadata = {
                "slug": slugs.get(doc.ident_hash),
                "title": doc.metadata.get("title"),
                "abstract": None
            }

            # Add / override metadata from baking if available
            json_metadata.update(baked_metadata.get(doc.ident_hash, {}))

            json.dump(
                json_metadata,
                json_out
            )

if __name__ == "__main__":
    main()