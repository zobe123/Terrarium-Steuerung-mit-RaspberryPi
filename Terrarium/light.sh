#!/bin/bash
address="0x20"
licht=14

finish() {
	echo " Ciao !!";
	i2cset -y 1 "$address" "0xff"
}
trap finish EXIT


while true
do

    date=$(date +%k%M)
    echo

    if (( "$date" > 700 && "$date" < 1900 ))
    then
        if (( "$date" > 900 && "$date" < 1700 ))
        then
            echo -n "UV EIN, "
        else
            echo -n "UV AUS, "
        fi
        i2c=$(i2cget -y 1 $address)
        i2cset -y 1 "$address" $(($i2c & ~$licht))
        echo -n "Licht EIN || "
    else
        i2c=$(i2cget -y 1 $address)
        i2cset -y 1 "$address" $(($i2c | $licht))
        echo -n "Licht AUS || "
    fi

    sleep 30

done
