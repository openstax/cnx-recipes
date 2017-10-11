# -*- coding: utf-8 -*-
import versioneer
from setuptools import setup

description = "CSS-transform (CSSt) recipes used to bake openstax books"
setup(name='cnx-recipes',
      version=versioneer.get_version(),
      cmdclass=versioneer.get_cmdclass(),
      description=description,
      url='http://github.com/Connexions/cnx-recipes',
      author='Connexions/OpenStax Team',
      author_email='info@cnx.org',
      license='LGPL, see also LICENSE.txt',
      packages=['cnxrecipes'],
      include_package_data=True,
      zip_safe=True,
      )
