#!/bin/bash
#
# Sitrep Scraper - Fetchbot
#

cat /etc/os-release

cd /github/workspace/.github/actions/fetchbot || exit

pip install --upgrade pip
pip install -r requirements.txt

pip --version
python --version

python ./main.py
