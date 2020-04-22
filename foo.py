from lxml import etree
from io import StringIO

temp = ''

with open('data/chemistry-2e/collection.assembled.xhtml', 'r') as myfile:
    fileContents=myfile.read()
    xml = etree.fromstring(fileContents)

    # https://github.com/openstax/cnx-cssselect2
    # CSS:                 [ data-type="chapter"]
    chapters = xml.xpath('*[@data-type="chapter"]')

    i = 0
    for c in chapters:
        if i != 12
            c.remove()
        i++

    print(etree.tostring(xml))
