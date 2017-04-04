#!/bin/bash
address="0x21"


finish() {
	echo " Ciao !!";
	i2cset -y 1 "$address" "0xff"
}
trap finish EXIT

i2cset -y 1 "$address" "0xff"
