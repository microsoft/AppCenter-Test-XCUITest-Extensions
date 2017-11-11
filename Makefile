.PHONY:	build carthage

all:
	$(MAKE) clean
	$(MAKE) build

clean:
	rm -rf build
	rm -rf Products

build:
	bin/make/build.sh

pod-lint:
	bin/make/pod-lint.sh

carthage:
	bin/make/carthage.sh

test-x86:
	bin/make/test.sh x86

test-arm:
	bin/make/test.sh arm
