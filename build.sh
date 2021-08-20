#!/bin/bash
set -e

: ${MODEL:=c18}
: ${KEYMAP:=default}
: ${MODULES:=all}
: ${FLASH:=yes}

KEYMAP_FILENAME="ap2-${MODEL}-${KEYMAP}.bin"
SHINE_FILENAME="ap2-${MODEL}-shine.bin"

if [[ $MODULES =~ (all|keymap) ]]; then
	[[ -d "/src/keymaps/$KEYMAP" ]] && cp -r /src/keymaps/$KEYMAP ~/qmk/keyboards/annepro2/keymaps
	cd ~/qmk
	ALLOW_WARNINGS=yes make annepro2/${MODEL,,}:$KEYMAP
	cp ~/qmk/.build/annepro2_c18_$KEYMAP.bin /build/$KEYMAP_FILENAME
fi

if [[ $MODULES =~ (all|shine) ]]; then
	[[ -d "/src/shine" ]] && cp /src/shine/* ~/shine/source
	cd ~/shine
	make ${MODEL^^}
	cp ~/shine/build/annepro2-shine-C18.bin /build/$SHINE_FILENAME
fi

if [ $FLASH == yes ]; then
	echo "Flashing in 10 seconds. Put the keyboard into IAP mode!"
	sleep 10
	cd ~/tools/target/release/
	[[ -f "/build/$KEYMAP_FILENAME" ]] && ./annepro2_tools /build/$KEYMAP_FILENAME
	[[ -f "/build/$SHINE_FILENAME" ]] && ./annepro2_tools --boot -t led /build/$SHINE_FILENAME
fi
