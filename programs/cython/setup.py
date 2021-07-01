# Link to bigger numbers
# https://gmpy2.readthedocs.io/en/latest/intro.html#installation

# Commande to compile
# python3.9 setup.py build_ext --inplace

from distutils.core import setup
from Cython.Build import cythonize

setup(ext_modules=cythonize("cprimes.pyx"))
