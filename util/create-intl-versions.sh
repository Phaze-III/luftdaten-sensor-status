#!/bin/sh

INTL_ERROR="Fehler"
INTL_NUMBER_OF_MEASUREMENTS="Anzahl Messungen"
INTL_TIME_SENDING_MS="Dauer Messübertragung"
INTL_DEVICE_STATUS="Gerätestatus"

for lang in bg cz dk en es fr hu it lu nl pl pt rs ru se sk tr ua
do
  cp -p "Sensor System Status-de.json" "Sensor System Status-${lang}.json"
done
while read lang var string
do
   case $var in
   INTL_NUMBER_OF_MEASUREMENTS)
       sed -i "" -e "s/\"${INTL_NUMBER_OF_MEASUREMENTS}\"/${string}/g" "Sensor System Status-${lang}.json"
   ;;
   INTL_TIME_SENDING_MS)
       sed -i "" -e "s/\"${INTL_TIME_SENDING_MS}\"/${string}/g" "Sensor System Status-${lang}.json"
   ;;
   INTL_ERROR)
       sed -i "" -e "s/\"${INTL_ERROR}\"/${string}/g" "Sensor System Status-${lang}.json"
   ;;
   INTL_DEVICE_STATUS)
       sed -i "" -e "s/\"${INTL_DEVICE_STATUS}\"/${string}/g" "Sensor System Status-${lang}.json"
   ;;
   esac
done <<EOT
bg INTL_DEVICE_STATUS "Статус на устройството"
bg INTL_ERROR "само грешки"
bg INTL_NUMBER_OF_MEASUREMENTS "Брой измервания"
bg INTL_TIME_SENDING_MS "Време, прекарано в изпращане"
cz INTL_DEVICE_STATUS "stav pohonu"
cz INTL_ERROR "chyba"
cz INTL_NUMBER_OF_MEASUREMENTS "Počet měření"
cz INTL_TIME_SENDING_MS "Poèet mìøení"
dk INTL_DEVICE_STATUS "Enhedsstatus"
dk INTL_ERROR "error"
dk INTL_NUMBER_OF_MEASUREMENTS "Antal målinger"
dk INTL_TIME_SENDING_MS "Tid brugt på afsendelse"
en INTL_DEVICE_STATUS "Device status"
en INTL_ERROR "only errors"
en INTL_NUMBER_OF_MEASUREMENTS "Number of measurements"
en INTL_TIME_SENDING_MS "Time spent uploading"
es INTL_DEVICE_STATUS "El estado del dispositivo"
es INTL_ERROR "Error"
es INTL_NUMBER_OF_MEASUREMENTS "Numero de mediciones"
es INTL_TIME_SENDING_MS "Tiempo empleado para enviar"
fr INTL_DEVICE_STATUS "Etat de l'appareil"
fr INTL_ERROR "erreur"
fr INTL_NUMBER_OF_MEASUREMENTS "Nombre de mesures"
fr INTL_TIME_SENDING_MS "Durée de la transmission des mesures"
hu INTL_DEVICE_STATUS "Eszköz státusz"
hu INTL_ERROR "csak hibajelzések"
hu INTL_NUMBER_OF_MEASUREMENTS "Mérések száma:"
hu INTL_TIME_SENDING_MS "Feltöltéssel töltött idő:"
it INTL_DEVICE_STATUS "Stato del dispositivo"
it INTL_ERROR "Errore"
it INTL_NUMBER_OF_MEASUREMENTS "Numero di misurazioni"
it INTL_TIME_SENDING_MS "Tempo impiegato per l'invio"
lu INTL_DEVICE_STATUS "Apparat Status"
lu INTL_ERROR "fehler"
lu INTL_NUMBER_OF_MEASUREMENTS "Zuel vu Mesuren"
lu INTL_TIME_SENDING_MS "Dauer vu Mesureniwerdroung"
nl INTL_DEVICE_STATUS "Apparaatstatus"
nl INTL_ERROR "enkel foutmeldingen"
nl INTL_NUMBER_OF_MEASUREMENTS "Aantal metingen"
nl INTL_TIME_SENDING_MS "Tijdsduur opsturen metingen"
pl INTL_DEVICE_STATUS "Stan urządzenia"
pl INTL_ERROR "Błędy"
pl INTL_NUMBER_OF_MEASUREMENTS "Liczba pomiarów"
pl INTL_TIME_SENDING_MS "Czas spędzony na wysyłce"
pt INTL_DEVICE_STATUS "Estado do dispositivo"
pt INTL_ERROR "erro"
pt INTL_NUMBER_OF_MEASUREMENTS "Quantidade de medições"
pt INTL_TIME_SENDING_MS "Duração da transmissão das medições"
rs INTL_DEVICE_STATUS "Status уређаја"
rs INTL_ERROR "greške"
rs INTL_NUMBER_OF_MEASUREMENTS "Broj merenja"
rs INTL_TIME_SENDING_MS "Vreme utrošeno za slanje"
ru INTL_DEVICE_STATUS "Состояние устройства"
ru INTL_ERROR "только ошибки"
ru INTL_NUMBER_OF_MEASUREMENTS "Количество измерений"
ru INTL_TIME_SENDING_MS "Время, потраченное на отправку"
se INTL_DEVICE_STATUS "Enhetsstatus"
se INTL_ERROR "error"
se INTL_NUMBER_OF_MEASUREMENTS "Antal mätningar"
se INTL_TIME_SENDING_MS "Tid som skickas i att skicka"
sk INTL_DEVICE_STATUS "Stav zariadenia"
sk INTL_ERROR "chyba"
sk INTL_NUMBER_OF_MEASUREMENTS "Počet meraní"
sk INTL_TIME_SENDING_MS "Trvanie odosielania dát"
tr INTL_DEVICE_STATUS "Cihaz durumu"
tr INTL_ERROR "hatalar"
tr INTL_NUMBER_OF_MEASUREMENTS "Ölçümlerin sayısı"
tr INTL_TIME_SENDING_MS "Göndermede harcanan süre"
ua INTL_DEVICE_STATUS "стан пристрою"
ua INTL_ERROR "лише помилки"
ua INTL_NUMBER_OF_MEASUREMENTS "Кількість вимірювань"
ua INTL_TIME_SENDING_MS "Час, витрачений на відправлення"
EOT
