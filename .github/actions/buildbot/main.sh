#!/bin/bash
#
# Sitrep Scraper
#

cat /etc/os-release

pip install --upgrade pip
pip install -r requirements.txt

pip --version
python --version

python ./main.py
