.PHONY: flash, image

SRC_DIR=$(PWD)
IMAGE_NAME=ap2-qmk:local
MODEL=c18
KEYMAP=default
MODULES=all
FLASH=no

all:
	@rm -rf ./build
	@mkdir build
	@docker run \
		--rm \
		--privileged \
		-e MODEL=$(MODEL) -e KEYMAP=$(KEYMAP) -e MODULES=$(MODULES) -e FLASH=$(FLASH) \
		-v $(SRC_DIR):/src -v $(PWD)/build:/build -v /dev:/dev \
		$(IMAGE_NAME) ./build.sh

flash: FLASH=yes
flash: all

image:
	docker build -t $(IMAGE_NAME) .
