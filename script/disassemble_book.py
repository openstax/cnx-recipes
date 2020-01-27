import sys
from pathlib import Path
from shutil import rmtree
from cnxepub.collation import reconstitute
from cnxepub.formatters import DocumentContentFormatter
from cnxepub.models import flatten_to, Document


if len(sys.argv) != 3:
    raise ValueError('2 arguments are necessary: data/BOOK_NAME/collection.baked.xhtml and the output dir data/BOOK_NAME/disassembled')

with open(sys.argv[1], "rb") as file:
    binder = reconstitute(file)


out_dir = Path(sys.argv[2]).resolve()
try:
    rmtree(out_dir)
except FileNotFoundError:
    pass
out_dir.mkdir()
for doc in flatten_to(binder, lambda d: isinstance(d, Document)):
    with open(f"{sys.argv[2]}/{doc.ident_hash}.xhtml", "wb") as out:
        out.write(bytes(DocumentContentFormatter(doc)))