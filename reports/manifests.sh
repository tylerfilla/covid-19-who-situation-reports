#!/bin/bash

template=$(cat <<EOS
{
  "number": _NUMBER,
  "when": {
    "year": _YEAR,
    "month": _MONTH,
    "day": _DAY
  },
  "revisions": [
    {
      "id": "_ID",
      "when": {
        "year": _REVYEAR,
        "month": _REVMONTH,
        "day": _REVDAY,
        "hour": _REVHOUR,
        "minute": _REVMINUTE,
        "second": _REVSECOND
      },
      "content": {
        "type": "pdf",
        "location": "_LOCATION",
        "metadata": {
          "author": "_MAUTHOR",
          "whenCreated": {
            "year": _WCYEAR,
            "month": _WCMONTH,
            "day": _WCDAY,
            "hour": _WCHOUR,
            "minute": _WCMINUTE,
            "second": _WCSECOND
          },
          "whenModified": {
            "year": _WMYEAR,
            "month": _WMMONTH,
            "day": _WMDAY,
            "hour": _WMHOUR,
            "minute": _WMMINUTE,
            "second": _WMSECOND
          }
        }
      }
    }
  ]
}
EOS
)

for x in $(seq 126 139); do
  pdf=$x/*$x.pdf
  pdfbn=$(basename $pdf)

  md5=$(md5sum $pdf | awk -F " " '{print $1}')

  strs=$(strings $pdf)

  nds=$(echo $pdfbn | awk -F "-" '{print $1}')
  eval $(dateutils.dconv "$nds" -i "%Y%m%d" -f "filename_year=%Y;filename_month=%-m;filename_day=%-d;")

  author=$(echo "$strs" | grep "dc:creator" | awk -F "[><]" '{print $7}')

  wcds=$(echo "$strs" | grep "xmp:CreateDate" | awk -F "[><]" '{print $5}')
  wmds=$(echo "$strs" | grep "xmp:ModifyDate" | awk -F "[><]" '{print $9}')

  # FIXME: THIS WON'T WORK YET
  eval $(dateutils.dconv "$wcds" -f "wc_year=%Y;wc_month=%-m;wc_day=%-d;wc_hour=%-H;wc_minute=%-M;wc_second=%-S")
  eval $(dateutils.dconv "$wmds" -f "wm_year=%Y;wm_month=%-m;wm_day=%-d;wm_hour=%-H;wm_minute=%-M;wm_second=%-S")

  echo "$template" \
    | sed -e s/_NUMBER/$x/g \
    | sed -e s/_YEAR/$filename_year/g \
    | sed -e s/_MONTH/$filename_month/g \
    | sed -e s/_DAY/$filename_day/g \
    | sed -e s/_ID/$md5/g \
    | sed -e s/_REVYEAR/$wm_year/g \
    | sed -e s/_REVMONTH/$wm_month/g \
    | sed -e s/_REVDAY/$wm_day/g \
    | sed -e s/_REVHOUR/$wm_hour/g \
    | sed -e s/_REVMINUTE/$wm_minute/g \
    | sed -e s/_REVSECOND/$wm_second/g \
    | sed -e s/_LOCATION/$pdfbn/g \
    | sed -e s/_MAUTHOR/$author/g \
    | sed -e s/_WCYEAR/$wc_year/g \
    | sed -e s/_WCMONTH/$wc_month/g \
    | sed -e s/_WCDAY/$wc_day/g \
    | sed -e s/_WCHOUR/$wc_hour/g \
    | sed -e s/_WCMINUTE/$wc_minute/g \
    | sed -e s/_WCSECOND/$wc_second/g \
    | sed -e s/_WMYEAR/$wm_year/g \
    | sed -e s/_WMMONTH/$wm_month/g \
    | sed -e s/_WMDAY/$wm_day/g \
    | sed -e s/_WMHOUR/$wm_hour/g \
    | sed -e s/_WMMINUTE/$wm_minute/g \
    | sed -e s/_WMSECOND/$wm_second/g \
    > $x/manifest.json

  echo
done
