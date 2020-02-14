import sys
from pathlib import Path

from lxml import etree
from lxml.builder import ElementMaker, E

from cnxepub.collation import reconstitute
from cnxepub.html_parsers import HTML_DOCUMENT_NAMESPACES
from cnxepub.formatters import DocumentContentFormatter
from cnxepub.models import flatten_to, Document

in_dir = Path(sys.argv[1]).resolve(strict=True)
out_dir = (in_dir / "disassembled").resolve(strict=True)
baked_file = (in_dir / "collection.baked.xhtml").resolve(strict=True)

with open(baked_file, "rb") as file:
    html_root = etree.parse(file)
    binder = reconstitute(file)

nav = html_root.xpath("//xhtml:nav", namespaces=HTML_DOCUMENT_NAMESPACES)[0]

toc_maker = ElementMaker(namespace=None,
                         nsmap={None: "http://www.w3.org/1999/xhtml"})
toc = toc_maker.html(E.head(E.title("Table of Contents")),
                     E.body(nav))

with open(f"{out_dir}/collection.toc.xhtml", "wb") as out:
    out.write(etree.tostring(toc, encoding="utf8", pretty_print=True))

for doc in flatten_to(binder, lambda d: isinstance(d, Document)):
    with open(f"{out_dir / doc.ident_hash}.xhtml", "wb") as out:
        # TODO: Copy resources from module to here (from raw_dir?)
        out.write(bytes(DocumentContentFormatter(doc)))

# Publishing calls these and these are needed to generate json,
# but they are harder to reach (cnx-publishing -> cnx-common)
# 
# https://github.com/openstax/cnx-publishing/blob/master/cnxpublishing/bake.py#L92
# tree = model_to_tree(binder)
# amend_tree_with_slugs(tree)

