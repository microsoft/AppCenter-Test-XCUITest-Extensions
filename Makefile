.PHONY:	build carthage

all:
	$(MAKE) clean
	$(MAKE) build

clean:
	rm -rf build

build:
	bin/make/build.sh

pod-lint:
	bin/make/pod-lint.sh

carthage:
	bin/make/carthage.sh

test:
	bin/make/test.sh
