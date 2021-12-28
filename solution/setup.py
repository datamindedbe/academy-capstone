from glob import glob

from os.path import basename
from os.path import splitext

from setuptools import find_packages, setup


setup(
    name="academy_capstone",
    version="0.0.1",
    python_requires=">=3.7, <3.8",
    packages=find_packages("academy_capstone"),
    # package_dir={"": "academy_capstone"},
    py_modules=[splitext(basename(path))[0] for path in glob("academy_capstone/*.py")],
    include_package_data=True,
)