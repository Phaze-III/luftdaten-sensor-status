#!/bin/sh

# Set this to the status URL of your sensor
StatusURL="${LuftdatenStatusURL:-http://192.168.1.42/status}"
# Change to keep a HTML copy
StatusPage="/dev/null"

# InfluxDB settings
INFLUXDB_DATABASE="${INFLUXDB_DATABASE:-sensor-status}"
INFLUXDB_HOST="${INFLUXDB_HOST:-localhost}"
INFLUXDB_PORT="${INFLUXDB_PORT:-8086}"
INFLUXDB_PRECISION="${INFLUXDB_PRECISION:-s}"

TimeStamp=${TimeStamp:-$(date -u +%s)}

curl -sS --connect-timeout 20 "${StatusURL}" |\
    tee ${StatusPage} |\
    html2text -ascii |\
    awk -F\| -v OFS=, -v ts=${TimeStamp} \
      '
                        { gsub(/.\b/, "", $0) ; gsub(/  +/, "", $0) ; gsub(/ \|/, "", $0) }  # original html2text
                        { gsub(/__+/, "", $0) ; gsub(/_/, " ", $0)  ; gsub(/  +/, " ", $0) } # debian-patched html2text
       /ID:/            { gsub(/ID: +/, "", $1) ; gsub(/ (.*)/, "", $1) ; Sensor=$1 ; next }
       /Firmware:/      { 
                          key = "Firmware" ; 
                          gsub(/Firmware: +/, "", $1) ;
                          print Sensor ",key=" key " string=\"" $1 "\" " ts ;
                          gsub(/NRZ-....-/, "", $1) ;
                          gsub(/-.*/, "", $1) ;
                          Version = $1 ;
                          next ;
                        }
       !/\|/            { next }
       /\|[A-Za-z0-9]+/ { 
                          if ( $2 ~ /^ *$|^(Par|Пара)|Firmware/) { next } ;
                          if ( $3 ~ /^ *$/) { next } ;
                          gsub(/ ms$/, "", $3) ;
                          gsub(/ %$/, "", $3) ;
                          key = $2 ;
                          fields = "";
                          reason = "" ;
                        }
       /SDS011.*[A-Za-z]+/                { key = ( $2 " Version" ) }
       /WiFi|SDS011[|0-9]+$|Data Send\|/  { key = ( key " Errors" ) }
       /SPS30[|0-9]+$/                    { key = ( key " Errors" ) }
       key ~ /Sensor.Community|Madavi.de|OpenSenseMap.org|Feinstaub-App|aircms.online|InfluxDB|Custom/ \
                                          { key = ( key " API" ) }
       /Reset Reason/   {
                          reason = $3 ;
                          gsub(/^[ \t]+|[ \t]+$/, "", reason) ;
                          gsub(/ /, "\\ ", reason) ;
                          fields=( reason "=true," );
                        }
       /Uptime|Last OTA/ {
                          days=0; hours=0; mins=0; secs=0;
                          split($3, time, ",");
                          for (i in time) {
                             if (time[i] ~ / days/)  { gsub(/^ | days/, "", time[i])  ; days=time[i] } ;
                             if (time[i] ~ / hours/) { gsub(/^ | hours/, "", time[i]) ; hours=time[i] } ;
                             if (time[i] ~ / min/)   { gsub(/^ | min/, "", time[i])   ; mins=time[i] } ;
                             if (time[i] ~ /s$/)     { gsub(/^ |s$/, "", time[i])     ; secs=time[i] } ;
                          }
                          Seconds = 24 * 3600 * days + 3600 * hours + 60 * mins + secs ;
                          fields=( "value=" Seconds "," );
                        }
                        {
                          gsub(/ /, "\\ ", key) ;
                          if ( $3 ~ /^[0-9]+$/) {
                             fields=( fields "value=" $3 ) ;
                          } else { 
                             fields=( fields "string=\"" $3 "\"" ) ;
                          }
                          print Sensor ",key=" key " " fields " " ts ;
                          if ( key == "Uptime" && Seconds < 900 ) {
                             if ( Version >= 130 ) {
                                split("Sensor.Community|Madavi.de|OpenSenseMap.org|Feinstaub-App|aircms.online|InfluxDB|Custom", API, "|");
                                for ( api in API ) {
                                  print Sensor ",key=" API[api] "\\ API value=0 " ts ;
                                }
                             } else {
                                print Sensor ",key=Data\\ Send\\ Errors value=0 " ts ;
                             }
                          }
                        }
      ' | curl -sS -X POST --data-binary @/dev/stdin \
             "http://${INFLUXDB_HOST}:${INFLUXDB_PORT}/write?db=${INFLUXDB_DATABASE}&precision=${INFLUXDB_PRECISION}"
