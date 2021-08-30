#!/bin/bash
set -e

: ${MODEL:=c18}
: ${KEYMAP:=default}
: ${MODULES:=all}
: ${FLASH:=yes}

keymap_filename="ap2-${MODEL}-${KEYMAP}.bin"
shine_filename="ap2-${MODEL}-shine.bin"

if [[ $MODULES =~ (all|keymap) ]]; then
	[[ -d "/src/keymaps/$KEYMAP" ]] && cp -r /src/keymaps/$KEYMAP ~/qmk/keyboards/annepro2/keymaps
	cd ~/qmk
	ALLOW_WARNINGS=yes make annepro2/${MODEL,,}:$KEYMAP
	cp ~/qmk/.build/annepro2_$MODEL_$KEYMAP.bin /build/$keymap_filename
	boot_at="keymap"
fi

if [[ $MODULES =~ (all|shine) ]]; then
	[[ -d "/src/shine" ]] && cp /src/shine/* ~/shine/source
	cd ~/shine
	make ${MODEL^^}
	cp ~/shine/build/annepro2-shine-$MODEL.bin /build/$shine_filename
	boot_at="shine"
fi

if [[ "$FLASH" == "yes" ]]; then
	echo "Flashing in 10 seconds. Put the keyboard into IAP mode!"
	sleep 10
	cd ~/tools/target/release/

	if [[ -f "/build/$keymap_filename" ]]; then
		[[ "$boot_at" == "keymap" ]] && boot="--boot"
		./annepro2_tools $boot -t main /build/$keymap_filename
	fi

	if [[ -f "/build/$shine_filename" ]]; then
		[[ "$boot_at" == "shine" ]] && boot="--boot"
		./annepro2_tools $boot -t led /build/$shine_filename
	fi
fi
