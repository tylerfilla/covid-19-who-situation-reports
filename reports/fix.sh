#!/bin/bash

revision() {
  path="$1"
  repnum="$2"
  revnum="$3"

  # Get absolute path to the document
  pdf=$(readlink -f "$path"/../../../files/"$(cat "$path"/content/location)")

  # Extract oddly-formatted CST date strings from the document metadata
  pdfcds=$(pdfinfo "$pdf" | grep "CreationDate:" | cut -d ':' -f 2- - | tr -s " " | cut -c 2-)
  pdfmds=$(pdfinfo "$pdf" | grep "ModDate:" | cut -d ':' -f 2- - | tr -s " " | cut -c 2-)

  # Convert weird CST date strings into proper UTC Unix timestamps in seconds
  pdfcdu=$(dateutils.dconv -i "%a %b %-d %H:%M:%S %Y" -f "%s" --from-zone=CST "$pdfcds")
  pdfmdu=$(dateutils.dconv -i "%a %b %-d %H:%M:%S %Y" -f "%s" --from-zone=CST "$pdfmds")

  echo $repnum $revnum

  dateutils.dconv -i "%s" -f "%Y" $pdfmdu > "$path"/when/year
  dateutils.dconv -i "%s" -f "%-m" $pdfmdu > "$path"/when/month
  dateutils.dconv -i "%s" -f "%-d" $pdfmdu > "$path"/when/day
  dateutils.dconv -i "%s" -f "%-H" $pdfmdu > "$path"/when/hour
  dateutils.dconv -i "%s" -f "%-M" $pdfmdu > "$path"/when/minute
  dateutils.dconv -i "%s" -f "%-S" $pdfmdu > "$path"/when/second

  dateutils.dconv -i "%s" -f "%Y" $pdfcdu > "$path"/content/meta/whenCreated/year
  dateutils.dconv -i "%s" -f "%-m" $pdfcdu > "$path"/content/meta/whenCreated/month
  dateutils.dconv -i "%s" -f "%-d" $pdfcdu > "$path"/content/meta/whenCreated/day
  dateutils.dconv -i "%s" -f "%-H" $pdfcdu > "$path"/content/meta/whenCreated/hour
  dateutils.dconv -i "%s" -f "%-M" $pdfcdu > "$path"/content/meta/whenCreated/minute
  dateutils.dconv -i "%s" -f "%-S" $pdfcdu > "$path"/content/meta/whenCreated/second

  dateutils.dconv -i "%s" -f "%Y" $pdfmdu > "$path"/content/meta/whenModified/year
  dateutils.dconv -i "%s" -f "%-m" $pdfmdu > "$path"/content/meta/whenModified/month
  dateutils.dconv -i "%s" -f "%-d" $pdfmdu > "$path"/content/meta/whenModified/day
  dateutils.dconv -i "%s" -f "%-H" $pdfmdu > "$path"/content/meta/whenModified/hour
  dateutils.dconv -i "%s" -f "%-M" $pdfmdu > "$path"/content/meta/whenModified/minute
  dateutils.dconv -i "%s" -f "%-S" $pdfmdu > "$path"/content/meta/whenModified/second
}

report() {
  reportpath=$1

  for revpath in "$reportpath"/./data/revs/*/; do
    absrevpath=$(readlink -f "$revpath")
    repnum=$(basename "$reportpath" | sed 's/^0*//')
    revnum=$(basename "$revpath")

    revision "$absrevpath" "$repnum" "$revnum"
  done
  
  firstpdf=$(ls "$reportpath"/files/*.pdf | head -n 1)

  pdfdu=$(dateutils.dconv -i "%Y%m%d" -f "%s" $(basename "$firstpdf"))

  dateutils.dconv -i "%s" -f "%Y" $pdfdu > "$reportpath"/data/when/year
  dateutils.dconv -i "%s" -f "%-m" $pdfdu > "$reportpath"/data/when/month
  dateutils.dconv -i "%s" -f "%-d" $pdfdu > "$reportpath"/data/when/day
}

for reportpath in ./*/; do
  report "$reportpath"
done
