.PHONY: flash, image

MODEL = c18
KEYMAP = default
IMAGE_NAME = ap2-qmk:alpha

all:
	@if [ -z "$(DATA_DIR)" ]; then echo "error: DATA_DIR is required"; exit 1; fi
	@rm -rf ./build
	@mkdir build
	docker run --rm --privileged \
		-e MODEL=$(MODEL) -e KEYMAP=$(KEYMAP) \
		-v $(DATA_DIR):/data -v $(PWD)/build:/build -v /dev:/dev \
		$(IMAGE_NAME) ./build.sh

flash:
	@echo "Flashing in 10 seconds. Put the keyboard into IAP mode!"
	@sleep 10
	./build/ap2-tools ./build/ap2-$(MODEL)-$(KEYMAP).bin
	./build/$(TOOLS) --boot -t led ./build/ap2-$(MODEL)-shine.bin

image:
	docker build -t $(IMAGE_NAME) .
