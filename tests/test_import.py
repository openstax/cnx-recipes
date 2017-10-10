from cnxrecipes import __version__, recipes


def test_version():
    """Verify basic existence of recipes"""
    assert(__version__)


def test_recipe_existence():
    recipe_ids = [r['id'] for r in recipes]
    assert(recipe_ids)
    assert('statistics' in recipe_ids)
    assert('economics' in recipe_ids)
    assert(len(recipe_ids) > 10)


def test_recipe_length():
    recipe_d = {r['id']: {'recipe': r['file'], 'title': r['title']}
                for r in recipes}

    assert(len(recipe_d['statistics']['recipe']) > 10000)
    assert(recipe_d['statistics']['title'] == 'Statistics')
