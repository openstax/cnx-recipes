import json
from pkg_resources import resource_stream, resource_string

from ._version import get_versions
__version__ = get_versions()['version']
del get_versions

recipes = json.load(resource_stream(__name__, 'recipes/manifest.json'))
# Convert filenames to strings
for recipe in recipes:
    recipe['file'] = resource_string(__name__,
                                     'recipes/{}'.format(recipe['file'],))
