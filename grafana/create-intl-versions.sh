#!/bin/sh

INTL_NUMBER_OF_MEASUREMENTS="Anzahl Messungen"
INTL_TIME_SENDING_MS="Dauer Messübertragung"

for lang in bg cz dk en es fr it lu nl pl pt rs ru se tr ua
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
   esac
done <<EOT
bg INTL_NUMBER_OF_MEASUREMENTS "Брой измервания"
bg INTL_TIME_SENDING_MS "Време, прекарано в изпращане"
cz INTL_NUMBER_OF_MEASUREMENTS "Počet měření"
cz INTL_TIME_SENDING_MS "Poèet mìøení"
dk INTL_NUMBER_OF_MEASUREMENTS "Antal målinger"
dk INTL_TIME_SENDING_MS "Tid brugt på afsendelse"
en INTL_NUMBER_OF_MEASUREMENTS "Number of measurements"
en INTL_TIME_SENDING_MS "Time spent uploading"
es INTL_NUMBER_OF_MEASUREMENTS "Numero de mediciones"
es INTL_TIME_SENDING_MS "Tiempo empleado para enviar"
fr INTL_NUMBER_OF_MEASUREMENTS "Nombre de mesures"
fr INTL_TIME_SENDING_MS "Durée de la transmission des mesures"
it INTL_NUMBER_OF_MEASUREMENTS "Numero di misurazioni"
it INTL_TIME_SENDING_MS "Tempo impiegato per l'invio"
lu INTL_NUMBER_OF_MEASUREMENTS "Zuel vu Mesuren"
lu INTL_TIME_SENDING_MS "Dauer vu Mesureniwerdroung"
nl INTL_NUMBER_OF_MEASUREMENTS "Aantal metingen"
nl INTL_TIME_SENDING_MS "Tijdsduur opsturen metingen"
pl INTL_NUMBER_OF_MEASUREMENTS "Liczba pomiarów"
pl INTL_TIME_SENDING_MS "Czas spędzony na wysyłce"
pt INTL_NUMBER_OF_MEASUREMENTS "Quantidade de medições"
pt INTL_TIME_SENDING_MS "Duração da transmissão das medições"
rs INTL_NUMBER_OF_MEASUREMENTS "Broj merenja"
rs INTL_TIME_SENDING_MS "Vreme utrošeno za slanje"
ru INTL_NUMBER_OF_MEASUREMENTS "Количество измерений"
ru INTL_TIME_SENDING_MS "Время, потраченное на отправку"
se INTL_NUMBER_OF_MEASUREMENTS "Antal mätningar"
se INTL_TIME_SENDING_MS "Tid som skickas i att skicka"
tr INTL_NUMBER_OF_MEASUREMENTS "Ölçümlerin sayısı"
tr INTL_TIME_SENDING_MS "Göndermede harcanan süre"
ua INTL_NUMBER_OF_MEASUREMENTS "Кількість вимірювань"
ua INTL_TIME_SENDING_MS "Час, витрачений на відправлення"
