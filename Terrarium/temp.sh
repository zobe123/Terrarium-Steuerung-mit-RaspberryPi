#!/bin/bash
address="0x20"
tempziel=29
schwellwert=1
temp=0
pin=0x1
API="Pushbullet secret"
firstrun=25032017
error_date=$(date +%k%M)
error_counter=0
        

finish() {
	echo " Ciao !!";
	i2cset -y 1 "$address" "0xff"
}
trap finish EXIT


while true
do

    date=$(date +%k%M)

    if (( "$date" > 700 && "$date" < 1900 ))
    then 
        tempziel=29
    else
        tempziel=22
    fi
    
#        temp=$(python2.7 /root/Adafruit_Python_DHT/examples/AdafruitDHT.py 22 4 | grep -oP "(?<=Temp=)[0-9.]+")
        temp=$(/Terrarium/loldht 7 | grep -oP "(?<=Temperature = )[0-9.]+")
        temp2=$(/Terrarium/loldht 15 | grep -oP "(?<=Temperature = )[0-9.]+")
        
    
    if [[ ! $temp || ! $temp2 ]]
    then
    
        #error_date=$(date +%k%M)
        #error_counter=
        MSG=$(echo "Sensor defekt! %0ASensor1: $temp %0ASensor2: $temp2")
        $(curl -silent -o error.txt -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="Terrarium Alarm" -d body="$MSG")
        echo "Bad Data (Sensor1: $temp, Sensor2: $temp2)"
    else

        sens_diff=$(echo $temp - $temp2 | bc)
        sens_diff=${sens_diff#-}
        echo "###" $sens_diff "###"
        
        if [[ $sens_diff > 2.7 ]]
        then
            MSG=$(echo "Sensorunterschied zu groß, $sens_diff statt 2.7")
            $(curl -silent -o error.txt -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="Terrarium Alarm" -d body="$MSG")
            echo "Bad Data (Sensorunterschied zu groß, $sens_diff)"
        fi
        
        if (( "$date" > 900 && "$date" < 1900 ))
        then
            if [[ $temp < $(( $tempziel - $schwellwert - 1 )) ]]
            then
                MSG=$(echo "Temperatur nicht erreicht $temp statt $(( $tempziel - $schwellwert - 1 ))")
                $(curl -silent -o error.txt -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="Terrarium Alarm" -d body="$MSG")
                echo -n " (Message sent)"
            fi
        fi
    
        i2c=$(i2cget -y 1 $address)

        binary=$(echo "obase=2; ibase=16; $(echo ${i2c:2:2} | tr /a-z/ /A-Z/)" | bc)
        echo -n $binary "-> "
        
        if [[ $temp > $(( $tempziel + $schwellwert )) ]]
        then
                echo -n $temp$'\xc2\xb0'C "-> abkühlen bis" $(( $tempziel - $schwellwert ))$'\xc2\xb0'C "|| "
                i2cset -y 1 "$address" $(($i2c | $pin))
        else
            if [[ $temp < $(( $tempziel - $schwellwert )) ]]
            then
                echo -n $temp$'\xc2\xb0'C "-> heizen bis" $(( $tempziel + $schwellwert ))$'\xc2\xb0'C "|| "
                i2cset -y 1 "$address" $(($i2c & ~$pin))
            else
                echo -n $temp$'\xc2\xb0'C "-> Temp. OK || "
            fi
        fi
    fi
    
    sleep 30

done