#!/bin/sh

INTL_ERROR="Fehler"
INTL_NUMBER_OF_MEASUREMENTS="Anzahl Messungen"
INTL_TIME_SENDING_MS="Dauer Messübertragung"
INTL_DEVICE_STATUS="Gerätestatus"

for lang in bg br cn cz dk ee en es fi fr gr hr hu it jp lt lu lv nl pl pt ro rs ru se si sk tr ua
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
br INTL_DEVICE_STATUS "Status do dispositivo"
br INTL_ERROR "erro"
br INTL_NUMBER_OF_MEASUREMENTS "Quantidade de medições"
br INTL_TIME_SENDING_MS "Duração de transmissão de medições"
cn INTL_DEVICE_STATUS "设备状态"
cn INTL_ERROR "唯恐有误"
cn INTL_NUMBER_OF_MEASUREMENTS "测量数量"
cn INTL_TIME_SENDING_MS "上传时间"
cz INTL_DEVICE_STATUS "Stav zařízení"
cz INTL_ERROR "chyba"
cz INTL_NUMBER_OF_MEASUREMENTS "Počet měření"
cz INTL_TIME_SENDING_MS "Doba nahrávání"
dk INTL_DEVICE_STATUS "Enhedsstatus"
dk INTL_ERROR "error"
dk INTL_NUMBER_OF_MEASUREMENTS "Antal målinger"
dk INTL_TIME_SENDING_MS "Tid brugt på afsendelse"
ee INTL_DEVICE_STATUS "Seadme olek"
ee INTL_ERROR "ainult vead"
ee INTL_NUMBER_OF_MEASUREMENTS "Mõõtmiste arv"
ee INTL_TIME_SENDING_MS "Üleslaadimisele kuluv aeg"
en INTL_DEVICE_STATUS "Device status"
en INTL_ERROR "only errors"
en INTL_NUMBER_OF_MEASUREMENTS "Number of measurements"
en INTL_TIME_SENDING_MS "Time spent uploading"
es INTL_DEVICE_STATUS "El estado del dispositivo"
es INTL_ERROR "Error"
es INTL_NUMBER_OF_MEASUREMENTS "Numero de mediciones"
es INTL_TIME_SENDING_MS "Tiempo empleado para enviar"
fi INTL_DEVICE_STATUS "Laitteen tila"
fi INTL_ERROR "vain virheet"
fi INTL_NUMBER_OF_MEASUREMENTS "Mittausten lukumäärä"
fi INTL_TIME_SENDING_MS "Lataamiseen käytetty aika"
fr INTL_DEVICE_STATUS "Etat de l'appareil"
fr INTL_ERROR "erreur"
fr INTL_NUMBER_OF_MEASUREMENTS "Nombre de mesures"
fr INTL_TIME_SENDING_MS "Durée de la transmission des mesures"
gr INTL_DEVICE_STATUS "Κατάσταση συσκευής"
gr INTL_ERROR "μόνο σφάλματα"
gr INTL_NUMBER_OF_MEASUREMENTS "Αριθμός μετρήσεων"
gr INTL_TIME_SENDING_MS "Χρόνος μεταφόρτωσης"
hr INTL_DEVICE_STATUS "Status uređaja"
hr INTL_ERROR "greške"
hr INTL_NUMBER_OF_MEASUREMENTS "Broj mjerenja"
hr INTL_TIME_SENDING_MS "Vrijeme utrošeno na slanje podataka"
hu INTL_DEVICE_STATUS "Eszköz státusz"
hu INTL_ERROR "csak hibajelzések"
hu INTL_NUMBER_OF_MEASUREMENTS "Mérések száma:"
hu INTL_TIME_SENDING_MS "Feltöltéssel töltött idő:"
it INTL_DEVICE_STATUS "Stato del dispositivo"
it INTL_ERROR "Errore"
it INTL_NUMBER_OF_MEASUREMENTS "Numero di misurazioni"
it INTL_TIME_SENDING_MS "Tempo impiegato per l'invio"
jp INTL_DEVICE_STATUS "デバイスの状態"
jp INTL_ERROR "エラーのみ"
jp INTL_NUMBER_OF_MEASUREMENTS "測定回数"
jp INTL_TIME_SENDING_MS "アップロードにかかった時間"
lt INTL_DEVICE_STATUS "Įrenginio būsena"
lt INTL_ERROR "tik klaidos"
lt INTL_NUMBER_OF_MEASUREMENTS "Matavimų skaičius"
lt INTL_TIME_SENDING_MS "Įkėlimo laikas"
lu INTL_DEVICE_STATUS "Apparat Status"
lu INTL_ERROR "fehler"
lu INTL_NUMBER_OF_MEASUREMENTS "Zuel vu Mesuren"
lu INTL_TIME_SENDING_MS "Dauer vu Mesureniwerdroung"
lv INTL_DEVICE_STATUS "Ierīces statuss"
lv INTL_ERROR "tikai kļūdas"
lv INTL_NUMBER_OF_MEASUREMENTS "Mērījumu skaits"
lv INTL_TIME_SENDING_MS "Laiks, kas pavadīts, augšupielādējot"
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
ro INTL_DEVICE_STATUS "Starea dispozitivului"
ro INTL_ERROR "numai erori"
ro INTL_NUMBER_OF_MEASUREMENTS "Număr de măsurători"
ro INTL_TIME_SENDING_MS "Timp petrecut la încărcare"
rs INTL_DEVICE_STATUS "Status uređaja"
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
si INTL_DEVICE_STATUS "Stanje naprave"
si INTL_ERROR "samo napake"
si INTL_NUMBER_OF_MEASUREMENTS "Število meritev"
si INTL_TIME_SENDING_MS "Čas, porabljen za nalaganje"
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
