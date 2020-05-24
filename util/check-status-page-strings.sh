#!/bin/sh

SrcDir="${SrcBase:-..}/sensors-software/airrohr-firmware"

if [ ! -r "${SrcDir}" ]
then
   echo Please set SrcDir
   exit 1
fi

echo "### Uptime related human readable strings:"
grep -h 'PSTR.*time_ms' "${SrcDir}"/*.ino "${SrcDir}"/*.cpp

echo "### INTL_PARAMETER string prefixes for get-sensor-status.sh"
grep 'INTL_PARAMETER' "${SrcDir}"/intl_??.h \
   | cut -d\" -f2 | cut -c1-3 | sort | uniq -c

echo "### List of languages:"
echo $(ls -1 "${SrcDir}"/intl_??.h | sed -e 's/^.*intl_\(..\).h.*/\1/')

echo "### List of INTL_* strings for Grafana Dashboard:"
egrep 'INTL_(ERROR|NUMBER_OF_MEASUREMENT|TIME_SENDING)' "${SrcDir}"/intl_??.h \
   | sed -e 's/^.*intl_//' -e 's/.h:#define//'
