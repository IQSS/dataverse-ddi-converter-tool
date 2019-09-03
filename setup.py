# coding: utf-8

import sys
from setuptools import setup, find_packages

NAME = "dct_server"
VERSION = "0.5.0"
# To install the library, run the following
#
# python setup.py install
#
# prerequisite: setuptools
# http://pypi.python.org/pypi/setuptools

REQUIRES = ["connexion"]

setup(
    name=NAME,
    version=VERSION,
    description="DDI Converter Tool",
    author_email="eko.indarto@dans.knaw.nl",
    url="",
    keywords=["Swagger", "DDI Converter Tool"],
    install_requires=REQUIRES,
    packages=find_packages(),
    package_data={'': ['swagger/swagger.yaml']},
    include_package_data=True,
    entry_points={
        'console_scripts': ['dct_server=dct_server.__main__:main']},
    long_description="""\
    DDI Converter Tool is an open source software for converting a DDI xml to Dataverse Metadata and its files\\ [DDI Converter Tool Github](https://github.com/ekoi/ddi-converter-tool). 
    """
)
