# luftdaten-sensor-status
Fetch system status info from a Sensor.Community (previously Luftdaten)
sensor and convert to influx line protocol

Includes a Grafana-dashboard to visualize the information.
# Requirements

Should work on most Unix(tm)/Linux flavours with the standard tools and
two additional packages (see Dependencies).

Tested on BSD (Mac OSX and FreeBSD) and airrohr-firmware NRZ-2020-129
to NRZ-2020-133 with a SDS011 sensor.

# Dependencies

The script depends on _curl_ and _html2text_, both most likely available in
the package repositories of your OS distribution. Source code is available
at:

* curl: https://curl.haxx.se/
* html2text: https://github.com/grobian/html2text

**No** Python required :)

# Usage

* Create a new InfluxDB with `create database "sensor-status"`
* Modify the Status\*- and INFLUXDB-settings in get-sensor-status.sh as needed
* Run the script from cron every 15 minutes

# Additional information

* https://sensor.community/en/sensors/airrohr/
* https://github.com/opendata-stuttgart/sensors-software
* https://luftdaten.info/
