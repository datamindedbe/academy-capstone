from glob import glob

from os.path import basename
from os.path import splitext

from setuptools import find_packages, setup

setup(
    name="academy_capstone",
    version="0.0.1",
    python_requires=">=3.6, <3.8",
    packages=find_packages("src"),
    package_dir={"": "src"},
    # py_modules=[splitext(basename(path))[0] for path in glob("academy_capstone/*.py")],
    include_package_data=True,
    install_requires=["boto3==1.18.0",
                      "botocore==1.21.0",
                      "py-openaq==1.1.0",
                      "pyspark==3.1.2",
                      "pytest==6.2.4"],
)
