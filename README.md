# luftdaten-sensor-status
Fetch and convert system status info from a Luftdaten sensor to influx line protocol

# Requirements

Tested on BSD (Mac OSX and FreeBSD) and Luftdaten firmware NRZ-2020-129

# Dependencies

* curl (https://curl.haxx.se/)
* html2text (https://github.com/grobian/html2text)
* **No** Python :)

# Usage

* Create a new InfluxDB with 'create database "sensor-status"'
* Modify the Status\*- and INFLUXDB-settings in get-sensor-status.sh as needed
* Run the script from cron, for exampe every 15 minutes
