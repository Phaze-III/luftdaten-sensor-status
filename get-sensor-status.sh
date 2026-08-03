#!/bin/sh

# Set this to the status URL of your sensor. Alternatively call the
# script with the IP-address of your sensor as first parameter.
StatusURL="http://${1:-192.168.1.42}/status"
# Change to keep a HTML copy
StatusPage="/dev/null"
# Change to your Sensor ID if you want curl timings stored under your
# Sensor ID InfluxDB measurement in case of connection failures.
# Alternatively call the script with your Sensor ID as second parameter.
# 'unknown' is used otherwise.
SensorID="${2:-unknown}"

# InfluxDB settings
INFLUXDB_DATABASE="${INFLUXDB_DATABASE:-sensor-status}"
INFLUXDB_HOST="${INFLUXDB_HOST:-localhost}"
INFLUXDB_PORT="${INFLUXDB_PORT:-8086}"
INFLUXDB_PRECISION="${INFLUXDB_PRECISION:-s}"

# INTL strings to be used as awk variables
INTL_RESET_REASON="Reset Reason"
INTL_DATA_SEND_RETURN_CODE="Data Send Return"
INTL_LAST_OVER_THE_AIR="Last OTA"
INTL_UPTIME="Uptime"
INTL_REACHABLE="reachable"

# Pre-NRZ-2024-136-B2 strings used to 'untranslate' NRZ-2024-136-B2+ status pages
ORIG_RESET_REASON="Reset Reason"
ORIG_DATA_SEND_RETURN_CODE="Data Send Return"
ORIG_LAST_OVER_THE_AIR="Last OTA"
ORIG_UPTIME="Uptime"
ORIG_REACHABLE="reachable"
ORIG_HEAP_FRAGMENTATION="Heap Fragmentation"
ORIG_FREE_MEMORY="Free Memory"
ORIG_YES="Yes"
ORIG_NO="No"

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
    # 'Untranslate' NRZ-2024-136-B2+ Status page translations to
    # preserve backwards compatibility for now
    sed \
        -e "s/Daten senden Return Code/${ORIG_DATA_SEND_RETURN_CODE}/" \
        -e "s/Aktiv seit/${ORIG_UPTIME}/" \
        -e "s/Grund des Zurücksetzens/${ORIG_RESET_REASON}/" \
        -e "s/Heap Fragmentierung/${ORIG_HEAP_FRAGMENTATION}/" \
        -e "s/Freier Speicher/${ORIG_FREE_MEMORY}/" \
        -e "s/Letztes OTA/${ORIG_LAST_OVER_THE_AIR}/" \
        -e "s/Gegevens versturen Return Code/${ORIG_DATA_SEND_RETURN_CODE}/" \
        -e "s/Reden herstart/${ORIG_RESET_REASON}/" \
        -e "s/Heap fragmentatie/${ORIG_HEAP_FRAGMENTATION}/" \
        -e "s/Vrij geheugen/${ORIG_FREE_MEMORY}/" \
        -e "s/Laatste OTA/${ORIG_LAST_OVER_THE_AIR}/" \
        -e "s/erreichbar/${ORIG_REACHABLE}/g" \
        -e "s/bereikbaar/${ORIG_REACHABLE}/g" \
        -e "s/: Ja/: ${ORIG_YES}/g" \
        -e "s/: Nein/: ${ORIG_NO}/g" \
        -e "s/: Nee/: ${ORIG_NO}/g" \
        |\
    html2text -width 120 ${HTML2TEXT_ENCODING} |\
    awk -F\| -v OFS=, \
             -v ts=${TimeStamp} \
             -v Sensor=${SensorID} \
             -v reachable="${INTL_REACHABLE}" \
             -v ResetReason="${INTL_RESET_REASON}" \
             -v DataSendReturnCode="${INTL_DATA_SEND_RETURN_CODE}" \
             -v LastOTA="${INTL_LAST_OVER_THE_AIR}" \
             -v Uptime="${INTL_UPTIME}" \
      '
       BEGIN            { ntpcount = 0 }
                        { gsub(/\u00a0|\xc2\xa0/," ",$0) }  # replace NBSP (Unicode code point or multibyte UTF-8) with normal space
                        { gsub(/.\b/, "", $0) ; gsub(/  +/, "", $0) ; gsub(/ \|/, "|", $0) } # original html2text
                        { gsub(/__+/, "", $0) ; gsub(/_/, " ", $0)  ; gsub(/  +/, " ", $0) } # debian-patched html2text
                        { gsub(/\[\[/, "", $0) ; gsub(/\]\]/, "", $0) } # remove [[]] brackets from not yet translated items
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
       $0 ~ reachable   {
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
       key == ResetReason   {
                          reason = $3 ;
                          gsub(/^[ \t]+|[ \t]+$/, "", reason) ;
                          if ( tsboot > 1 ) {
                             gsub(/ /, "\\ ", key) ;
                             print Sensor ",Reset=1,key=" key " string=\"" reason "\",value=0,qtime=" ts " " tsboot ;
                             gsub(/\\ /, " ", key) ;
                          }
                        }
       key == Uptime || key == LastOTA {
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
                          if ( $3 ~ /^[0-9.]+$/ && key != DataSendReturnCode ) {
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
                          if ( key != Uptime && key != LastOTA && key != ResetReason ) {
                             gsub(/ /, "\\ ", key) ;
                             print Sensor ",key=" key " " fields " " ts ;
                          } else {
                             gsub(/ /, "\\ ", key) ;
                             print Sensor ",key=" key " " fields " " ts ;
                             gsub(/\\ /, " ", key) ;
                          }
                          if ( key == Uptime && Seconds < 3600 ) {
                             tsboot = ts - Seconds ;
                             gsub(/ /, "\\ ", LastOTA) ; gsub(/ /, "\\ ", DataSendReturnCode) ;
                             print Sensor ",Reset=1,key=" LastOTA " string=\"-\",value=0,qtime=" ts " " tsboot ;
                             print Sensor ",Reset=1,key=" DataSendReturnCode " string=\"-\",value=0,qtime=" ts " " tsboot ;
                             gsub(/\\ /, " ", LastOTA) ; gsub(/\\ /, " ", DataSendReturnCode) ;
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
