.PHONY: flash, image

IMAGE_NAME = ap2-qmk:local
MODEL = c18
KEYMAP = default
FLASH = true

all:
	@if [ -z "$(DATA_DIR)" ]; then echo "error: DATA_DIR is required"; exit 1; fi
	@rm -rf ./build
	@mkdir build
	docker run \
		--rm \
		--privileged=$(FLASH) \
		-e MODEL=$(MODEL) -e KEYMAP=$(KEYMAP) -e FLASH=$(FLASH) \
		-v $(DATA_DIR):/data -v $(PWD)/build:/build -v /dev:/dev \
		$(IMAGE_NAME) ./build.sh

image:
	docker build -t $(IMAGE_NAME) .
