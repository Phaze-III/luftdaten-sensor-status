# Sensor System Status Grafana dashboard

Dashboard to show system-related information about your
Sensor.Community-sensor.

The dashboard uses two InfluxDB data sources:

* sensor-status: information from the 'status' page as collected by the get-sensor-status.sh script
* luftdaten: system-related information from the 'Feinstaub' database as directly stored by your sensor 

Pick the appropriate language version for your sensor for importing into
Grafana.
