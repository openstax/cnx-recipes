# -*- coding: utf-8 -*-
import hashlib
from psycopg2 import Binary
from cnxrecipes import recipes, _version, __version__ as recipe_tag

recipe_hash = _version.get_versions()['full-revisionid']


def should_run(cursor):
    cursor.execute('SELECT count(*) from print_style_recipes where tag = %s',
                   (recipe_tag,))
    installed_recipe_count = cursor.fetchall()[0][0]
    return installed_recipe_count == 0


def up(cursor):
    """Insert all the recipes using the package version"""
    for recipe in recipes:
        sha1 = hashlib.new('sha1', recipe['file']).hexdigest()
        cursor.execute('SELECT fileid FROM files WHERE sha1 = %s', (sha1,))
        if cursor.rowcount != 0:
            fileid = cursor.fetchone()[0]
        else:
            cursor.execute("""INSERT INTO files (file) VALUES (%s)"""
                           """ RETURNING fileid""", (Binary(recipe['file']),))
            fileid = cursor.fetchone()[0]

        cursor.execute("""INSERT INTO"""
                       """ print_style_recipes"""
                       """ (print_style, title, fileid, tag, commit_id)"""
                       """ VALUES(%s, %s, %s, %s, %s)""",
                       (recipe['id'], recipe['title'],
                        fileid, recipe_tag, recipe_hash))


def down(cursor):
    """Delete any recipes from this package version"""
    cursor.execute('DELETE FROM print_style_recipes WHERE tag = %s',
                   (recipe_tag,))
