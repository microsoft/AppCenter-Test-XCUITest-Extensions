
all:
	$(MAKE) clean
	$(MAKE) build

.PHONY:
	build

clean:
	rm -rf build

build:
	bin/make/build.sh
