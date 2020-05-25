#!/bin/sh

SrcDirAirrohr="${SrcBase:-..}/sensors-software/airrohr-firmware"
SrcDirArduino="${SrcBase:-..}/Arduino/cores/esp8266"

if [ ! -r "${SrcDirArduino}" ]
then
   echo Please set SrcDirArduino
else
   echo "### Reset Reasons:"
   grep -h 'case REASON_' "${SrcDirArduino}"/*.cpp
fi

if [ ! -r "${SrcDirAirrohr}" ]
then
   echo Please set SrcDirAirrohr
else
   echo "### Uptime related human readable strings:"
   grep -h 'PSTR.*time_ms' "${SrcDirAirrohr}"/*.ino "${SrcDirAirrohr}"/*.cpp

   echo "### INTL_PARAMETER string prefixes for get-sensor-status.sh"
   grep 'INTL_PARAMETER' "${SrcDirAirrohr}"/intl_??.h \
      | cut -d\" -f2 | cut -c1-3 | sort | uniq -c

   echo "### List of languages:"
   echo $(ls -1 "${SrcDirAirrohr}"/intl_??.h | sed -e 's/^.*intl_\(..\).h.*/\1/')

   echo "### List of INTL_* strings for Grafana Dashboard:"
   egrep 'INTL_(ERROR|NUMBER_OF_MEASUREMENT|TIME_SENDING)' "${SrcDirAirrohr}"/intl_??.h \
      | sed -e 's/^.*intl_//' -e 's/.h:#define//'
fi
