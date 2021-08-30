# annepro2-qmk-docker

Docker image for compiling and flashing OpenAnnePro firmwares

# Requirements

- Docker
- Make

# Basic Usage

1. Clone this repository:

    git clone --depth=1 https://github.com/mbenford/annepro2-qmk-docker

2. Build the docker image (this will take a few minutes to complete):

		cd annepro2-qmk-docker
		make image

2. Build and flash the firmwares (default keymap and Shine for model C18):

		make flash
	
You can also just run `make` to build the files only. They will be placed in `./build` so you can flash them manually.

# Advanced usage

## Using a different model

Use the `MODEL` variable to set what model you want to build/flash:

    make flash MODEL=c15

## Using a different keymap

You can build a different keymap by using the `KEYMAP` variable:

    make flash KEYMAP=default-full-caps

All keymaps in [the keymaps folder](https://github.com/OpenAnnePro/qmk_firmware/tree/keyboard-annepro2/keyboards/annepro2/keymaps)
can be used. You can also use your own keymaps as well by setting the `SRC_DIR` variable:

    make flash SRC_DIR=~/dotfiles/qmk/annepro KEYMAP=my-custom-keymap

`my-custom-keymap` must be a directory under `SRC_DIR/keymaps` containing your custom files - notably `keymap.c` and 
`config.h`.

## Using a custom Shine profile

You can provide your custom Shine files by using the `SRC_DIR` variable as well. All files must be located in 
`SRC_DIR/shine`.

## Building/flashing a specific module

You don't need to build and flash all modules (keymap and shine) all the time. Use the `MODULE` variable to specify
what you want to build:

    make flash MODULES=all    # all modules
    make flash MODULES=keymap # only keymap
    make flash MODULES=shine  # only shine

