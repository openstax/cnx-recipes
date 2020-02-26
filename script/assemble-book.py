import sys
import json
from cnxepub.collation import reconstitute
from cnxepub.models import flatten_to_documents

in_path, out_path = sys.argv[1:3]

json_data = {}

with open(in_path, "r") as in_file:
    binder = reconstitute(in_file)

for doc in flatten_to_documents(binder):
    abstract = doc.metadata.get("summary")
    json_data[doc.ident_hash] = { "abstract": abstract }

with open(out_path, "w") as out_file:
    json.dump(json_data, out_file)
