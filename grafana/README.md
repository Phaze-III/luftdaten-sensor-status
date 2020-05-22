# Sensor System Status Grafana dashboard

Dahsboard to show system-related information about your
Luftdaten-sensor.

The dashboard uses two InfluxDB data sources:

* sensor-status: information from the 'status' page as collected by the get-sensor-status.sh script
* luftdaten: system-related information from the 'Feinstaub' database as directly stored by your sensor 

The dashboard should be importable without manual changes **except** for
the two panels that are in German:

* Messungen
* Dauer Messübertragung

These will only work as-is when you have your sensor set to German. If
you use any other language please edit those panels as needed.
