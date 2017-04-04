# Terrarium-Steuerung-mit-RaspberryPi
simple Steuerung mittels RaspberryPi3 und i2C 8xRelais und DHT22 Sensor
(Gesamtkosten unter €100,-)


requires:
     i2c Tools
     mysql (Save Data)
     lighttpd (HTTP Server)

install:
  apt-get update
  apt-get install i2c-tools      # I2C-Toolkit fuer die Kommandozeile
  apt-get install python-smbus   # Python-Bibliothek fuer I2C
  apt-get install libi2c-dev     # Bibliothek fuer C
  apt-get install mysql
  apt-get install lighttpd
