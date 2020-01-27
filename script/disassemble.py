import sys
from pathlib import Path
from shutil import rmtree
from cnxepub.collation import reconstitute
from cnxepub.formatters import DocumentContentFormatter
from cnxepub.models import flatten_to, Document

in_dir = Path(sys.argv[1]).resolve(strict=True)
out_dir = (in_dir / "disassembled").resolve(strict=True)
# raw_dir = (in_dir / "raw").resolve(strict=True)
baked_file = (in_dir / "collection.baked.xhtml").resolve(strict=True)

with open(baked_file, "rb") as file:
    binder = reconstitute(file)

for doc in flatten_to(binder, lambda d: isinstance(d, Document)):
    with open(f"{out_dir / doc.ident_hash}.xhtml", "wb") as out:
        # TODO: Copy resources from module to here (from raw_dir?)
        out.write(bytes(DocumentContentFormatter(doc)))

# Publishing calls these and these are needed to generate json,
# but they are harder to reach (cnx-publishing -> cnx-common)
# 
# tree = model_to_tree(binder)
# amend_tree_with_slugs(tree)

