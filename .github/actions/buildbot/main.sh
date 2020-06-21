#!/bin/bash
#
# Sitrep Scraper - Buildbot
#

cat /etc/os-release

cd /github/workspace/.github/actions/buildbot || exit

pip install --upgrade pip
pip install -r requirements.txt

pip --version
python --version

python ./main.py
