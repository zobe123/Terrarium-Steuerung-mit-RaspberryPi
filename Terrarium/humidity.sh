#!/bin/bash
address="0x20"
humidityziel=50
schwellwert=5
humidity=5
pin=0xEF
API="Pushbullet secret"
firstrun=25032017
mysql_counter=10


finish() {
	echo " Ciao !!";
#	i2cset -y 1 "$address" "0xff"
}
trap finish EXIT


while true
do

    date=$(date +%k%M)
    date_mysql=$(date +%F" "%R)
    
#    echo -n ${date:0:2}:${date:2:2}" -> "

    
    #if [ "$date" -gt 700 ] && [ "$date" -lt 1900 ]
    if (( "$date" > 900 && "$date" < 1700 ))
    then 
        humidityziel=50
    else
        humidityziel=5
        #firstrun=$(date +%d%m%Y)
    fi
    

    i2c=$(i2cget -y 1 $address)

    binary=$(echo "obase=2; ibase=16; $(echo ${i2c:2:2} | tr /a-z/ /A-Z/)" | bc)
#    echo -n $binary " -> "
    

#        humidity=$(python2.7 /root/Adafruit_Python_DHT/examples/AdafruitDHT.py 22 4 | grep -oP "(?<=Humidity=)[0-9.]+")
        humidity=$(/Terrarium/loldht 15 | grep -oP "(?<=Humidity = )[0-9.]+")
        humidity2=$(/Terrarium/loldht 7 | grep -oP "(?<=Humidity = )[0-9.]+")

    if (( $(bc <<< "$humidity > 100") )) || [ ! $humidity ]
    #if [[ $humidity > 100 ]]
    then
        echo -n "Bad Data"
    else
#    echo -n $humidity
#    echo -n $humidity2
    #       mysql 
        (( mysql_counter++ ))
        if [ $mysql_counter -gt 10 ]
        then
            echo "INSERT INTO humidity_log (client_id, value_1, value_2, timestamp) VALUES ('1', '$humidity', '$humidity2', '$date_mysql');" | mysql -uroot -praspberry Terrarium
            mysql_counter=0
        fi
        
#        echo -n $firstrun "-> "
        if (( $(bc <<< "$humidity > $(( $humidityziel + $schwellwert ))") ))
        #if [[ $humidity > $(( $humidityziel + $schwellwert )) ]]
        then
                echo -n $humidity$'%' "-> Feuchtigk. senken bis" $(( $humidityziel - $schwellwert ))$'%' "|| "
                #i2cset -y 1 "$address" $(($i2c | $pin))
                #sleep 30
                #i2cset -y 1 "$address" $(($i2c | $pin))
                if (( $firstrun != $(date +%d%m%Y) && "$date" > 1200 ))
                then
                    MSG=$(echo "Feuchtigkeit ist zu hoch $humidity statt $(( $humidityziel - $schwellwert ))")
                    $(curl -silent -o error.txt -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="Terrarium Alarm" -d body="$MSG")
                    echo -n " (Message sent)"
                    firstrun=$(date +%d%m%Y)
                fi
        else
            if (( $(bc <<< "$humidity < $(( $humidityziel - $schwellwert ))") ))
            #if [[ $humidity < $(( $humidityziel - $schwellwert )) ]]
            then
                echo -n $humidity$'%' "-> Feuchtigk. erhöhen bis" $(( $humidityziel + $schwellwert ))$'%' "|| "
                #i2cset -y 1 "$address" $(($i2c & ~$pin))
                #sleep 30
                #i2cset -y 1 "$address" $(($i2c | $pin))
                if (( $firstrun != $(date +%d%m%Y) && "$date" > 1200 ))
                then
                    MSG=$(echo "Feuchtigkeit ist zu niedrig $humidity statt $(( $humidityziel + $schwellwert ))")
                    $(curl -silent -o error.txt -u $API: https://api.pushbullet.com/v2/pushes -d type=note -d title="Terrarium Alarm" -d body="$MSG")
                    echo -n " (Message sent)"
                    firstrun=$(date +%d%m%Y)
                fi
            else
                echo -n $humidity$'%' "-> Feuchtigk. OK || "
                firstrun=$(date +%d%m%Y)
            fi
        fi
    fi

    sleep 30
    #echo ""
done
