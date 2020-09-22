# luftdaten-sensor-status
Fetch system status info from a Luftdaten sensor and convert to influx line protocol

# Requirements

Should work on most Unix(tm)/Linux flavours with the standard tools and
two additional packages (see Dependencies).

Tested on BSD (Mac OSX and FreeBSD) and Luftdaten firmware NRZ-2020-129
and NRZ-2020-130-B6 to B9 with a SDS011 sensor.

# Dependencies

The script depends on curl and html2text, both most likely available in
the package repositories of your OS distribution. Source code is available
at:

* curl: https://curl.haxx.se/
* html2text: https://github.com/grobian/html2text

**No** Python required :)

# Usage

* Create a new InfluxDB with 'create database "sensor-status"'
* Modify the Status\*- and INFLUXDB-settings in get-sensor-status.sh as needed
* Run the script from cron every 15 minutes

# Additional information

* https://luftdaten.info/
* https://github.com/opendata-stuttgart/sensors-software
