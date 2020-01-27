# data/book-name/foobar.html -> data/book-name/foobar.json
import sys
from glob import glob
from os.path import basename
import json
import yaml
from lxml import etree

book_dir, out_dir = sys.argv[1:3]

files = [basename(x).rstrip(".xhtml") for x in glob(f"{book_dir}/*.xhtml")]

json_data = {}
filters = {}

with open("./script/tag_filter.yml", "r") as meta_filter:
    filters = yaml.load(meta_filter, Loader=yaml.FullLoader)

for path in files:
    with open(f"{book_dir}/{path}.xhtml", "rb") as book_part:
        content = book_part.read()
        json_data = { "content": str(content) }

        root = etree.fromstring(content, parser=etree.HTMLParser())
        meta_tags = root.xpath("//meta")
        meta_content = ""

        for tag in meta_tags:
            attrib = tag.attrib
            if attrib["name"] in filters:
                if filters[attrib["name"]] is not None:
                    # if list flag exists parse string as csv
                    if "list" in filters[attrib["name"]]:
                        meta_content = attrib["content"].split(",")
                else:
                    meta_content = attrib["content"]

                json_data[attrib["name"]] = meta_content

    with open(f"{out_dir}/{path}.json", 'w') as outfile:
        json.dump(json_data, outfile)
