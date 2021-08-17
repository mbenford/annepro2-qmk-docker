#!/bin/bash
set -e

: ${MODEL:=c18}
: ${KEYMAP:=default}
: ${FLASH:=true}

KEYMAP_FILENAME="ap2-${MODEL}-${KEYMAP}.bin"
SHINE_FILENAME="ap2-${MODEL}-shine.bin"

mkdir -p ~/qmk/keyboards/annepro2/keymaps/$KEYMAP
cp /data/keymaps/$KEYMAP/* ~/qmk/keyboards/annepro2/keymaps/$KEYMAP
cd ~/qmk
ALLOW_WARNINGS=yes make annepro2/${MODEL,,}:$KEYMAP

cp /data/shine/* ~/shine/source
cd ~/shine
make ${MODEL^^}

cp ~/qmk/.build/annepro2_c18_$KEYMAP.bin /build/$KEYMAP_FILENAME
cp ~/shine/build/annepro2-shine-C18.bin /build/$SHINE_FILENAME

if [ $FLASH == "true" ]; then
	echo "Flashing in 10 seconds. Put the keyboard into IAP mode!"
	sleep 10
	cd ~/tools/target/release/
	./annepro2_tools /build/$KEYMAP_FILENAME
	./annepro2_tools --boot -t led /build/$SHINE_FILENAME
fi
