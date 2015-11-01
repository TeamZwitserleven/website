BUILD_PATH := $(shell pwd)/.gobuild
HUGO := $(BUILD_PATH)/bin/hugo
PUBLISH_PATH := $(shell pwd)/.publish
COMMIT := $(shell git rev-parse --short HEAD)

.PHONY: all clean build publish watch

all: build

clean:
	rm -Rf public $(PUBLISH_PATH)

veryclean:
	rm -Rf public $(PUBLISH_PATH) $(BUILD_PATH)

build: $(HUGO)
	$(HUGO)

publish: clean build
	rm -Rf $(PUBLISH_PATH)
	mkdir -p $(PUBLISH_PATH)
	cd $(PUBLISH_PATH) && git clone git@github.com:TeamZwitserleven/TeamZwitserleven.github.io.git $(PUBLISH_PATH)
	rm -Rf $(PUBLISH_PATH)/*
	cp -r public/* $(PUBLISH_PATH)
	echo "www.teamzwitserleven.nl" > $(PUBLISH_PATH)/CNAME
	cd $(PUBLISH_PATH) && git status
	cd $(PUBLISH_PATH) && git add --all .
	cd $(PUBLISH_PATH) && git commit -m "Publish version $(COMMIT)"
	cd $(PUBLISH_PATH) && git push

watch: $(HUGO)
	$(HUGO) server -w

$(HUGO):
	GOPATH=$(BUILD_PATH) go get -v github.com/spf13/hugo
