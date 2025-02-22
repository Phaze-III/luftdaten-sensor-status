#!/bin/sh

# Set this to the status URL of your sensor
StatusURL="${LuftdatenStatusURL:-http://192.168.1.42/status}"
# Change to keep a HTML copy
StatusPage="/dev/null"
# Change to your Sensor ID if you want curl timings stored under your
# Sensor ID InfluxDB measurement in case of connection failures.
# 'unknown' is used otherwise.
SensorID="${LuftdatenSensorID:-unknown}"

# InfluxDB settings
INFLUXDB_DATABASE="${INFLUXDB_DATABASE:-sensor-status}"
INFLUXDB_HOST="${INFLUXDB_HOST:-localhost}"
INFLUXDB_PORT="${INFLUXDB_PORT:-8086}"
INFLUXDB_PRECISION="${INFLUXDB_PRECISION:-s}"

# Check for recent version of html2text
if html2text -help | grep -q utf8
then
  HTML2TEXT_ENCODING="-utf8"
else
  HTML2TEXT_ENCODING="-ascii"
fi

TimeStamp=${TimeStamp:-$(date -u +%s)}

curl -sS --connect-timeout 20 --max-time 60 \
     --write-out "<table >\r
                          <tr><td>curl-time-connect</td><td>%{time_connect}</td></tr>\r
                          <tr><td>curl-time-pretransfer</td><td>%{time_pretransfer}</td></tr>\r
                          <tr><td>curl-time-starttransfer</td><td>%{time_starttransfer}</td></tr>\r
                          <tr><td>curl-time-total</td><td>%{time_total}</td></tr>\r
                          <tr><td>curl-errormsg</td><td>%{errormsg}</td></tr>\r
                  </table>\r
                  </body>\r\n</html>\r\n" \
     "${StatusURL}" |\
    sed -e "s%</body></html>%%" |\
    tee ${StatusPage} |\
    sed "s/<table /<table border=\'1\' /" |\
    html2text -width 120 ${HTML2TEXT_ENCODING} |\
    awk -F\| -v OFS=, \
             -v ts=${TimeStamp} \
             -v Sensor=${SensorID} \
      '
       BEGIN            { ntpcount = 0 }
                        { gsub(/\u00a0|\xc2\xa0/," ",$0) }  # replace NBSP (Unicode code point or multibyte UTF-8) with normal space
                        { gsub(/.\b/, "", $0) ; gsub(/  +/, "", $0) ; gsub(/ \|/, "", $0) }  # original html2text
                        { gsub(/__+/, "", $0) ; gsub(/_/, " ", $0)  ; gsub(/  +/, " ", $0) } # debian-patched html2text
       /ID:/            { gsub(/ID: +/, "", $1) ; gsub(/ (.*)/, "", $1) ; Sensor=$1 ; next }
       /:.*NRZ-....-/   {
                          key = "Firmware" ; 
                          gsub(/.*: +/, "", $1) ;
                          print Sensor ",key=" key " string=\"" $1 "\" " ts ;
                          gsub(/NRZ-....-/, "", $1) ;
                          gsub(/[\/-].*/, "", $1) ;
                          Version = $1 ;
                          next ;
                        }
       /reachable/      {
                          if ( /\|NTP Info\|/ )
                          {
                            ntp = $3 ;
                          } else {
                            ntp = ( ntp "\n" $3 )
                          }
                          ntpcount += 1
                          next
                        }
       !/\|/            { key = "" ; next }
       /\|[[:alnum:]]+/ { 
                          key = "" ;
                          if ( $2 ~ /^ *$|^(Par|Пара|参数|Παρ|パラメ)|Firmware/) { next } ;
                          if ( $3 ~ /^ *$|^[[:alnum:]]+:/) { next } ;
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
                          if ( tsboot > 1 ) {
                             print Sensor ",Reset=1,key=Reset\\ Reason string=\"" reason "\",value=0,qtime=" ts " " tsboot ;
                          }
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
       key != ""        {
                          if ( $3 ~ /^[0-9.]+$/ && key != "Data Send Return" ) {
                             fields=( fields "value=" $3 ) ;
                          } else { 
                             fields=( fields "string=\"" $3 "\"" ) ;
                             if ( key == "WiFi Errors" ) {
                                gsub(/\/.*/, "", $3) ;
                                if ( $3 ~ /^[0-9.]+$/) {
                                   fields=( fields ",value=" $3 ) ;
                                }
                             }
                          }
                          gsub(/ /, "\\ ", key) ;
                          print Sensor ",key=" key " " fields " " ts ;
                          if ( key == "Uptime" && Seconds < 3600 ) {
                             tsboot = ts - Seconds ;
                             print Sensor ",Reset=1,key=Last\\ OTA string=\"-\",value=0,qtime=" ts " " tsboot ;
                             print Sensor ",Reset=1,key=Data\\ Send\\ Return string=\"-\",value=0,qtime=" ts " " tsboot ;
                             split("Wifi|SDS011|Sensirion\\ SPS30", ERRORS, "|") ;
                             for ( error in ERRORS ) {
                                print Sensor ",Reset=1,key=" ERRORS[error] "\\ Errors value=0,qtime=" ts " " tsboot ;
                             }
                             if ( Version >= 130 ) {
                                split("Sensor.Community|Madavi.de|OpenSenseMap.org|Feinstaub-App|aircms.online|InfluxDB|Custom", API, "|");
                                for ( api in API ) {
                                  print Sensor ",Reset=1,key=" API[api] "\\ API value=0,qtime=" ts " " tsboot ;
                                }
                             } else {
                                print Sensor ",Reset=1,key=Data\\ Send\\ Errors value=0,qtime=" ts " " tsboot ;
                             }
                          }
                        key = "" ;
                        }
       END              {
                          if ( ntpcount >= 1 )
                          {
                              print Sensor ",key=NTP\\ Info string=\"" ntp "\" " ts ;
                          }
                        }
      ' | curl -sS -X POST --data-binary @/dev/stdin \
             "http://${INFLUXDB_HOST}:${INFLUXDB_PORT}/write?db=${INFLUXDB_DATABASE}&precision=${INFLUXDB_PRECISION}"
