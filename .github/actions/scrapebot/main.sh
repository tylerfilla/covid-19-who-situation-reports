#!/bin/bash
#
# Sitrep Scraper - Scrapebot
#

cat /etc/os-release

cd /github/workspace/.github/actions/scrapebot || exit

pip install --upgrade pip
pip install -r requirements.txt

pip --version
python --version

python ./main.py
