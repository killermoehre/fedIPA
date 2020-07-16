ifeq ($(UID),0)
	mkosi = ./mkosi/mkosi
	qemu = qemu-system-x86_64
	rm = rm
else
	mkosi = sudo ./mkosi/mkosi
	qemu = sudo qemu-system-x86_64
	rm = sudo rm
endif

DISTRIBUTION ?= fedora

.PHONY: default
default: git-submodule-init clean build

.PHONY: all
all: git-submodule-init clean build-all

.PHONY: clean
clean:
	$(rm) -rf mkosi.builddir/fedipa.*
	$(mkosi) clean

.PHONY: build
build:
	$(mkosi) build

.PHONY: build-all
build-all:
	$(mkosi) --all build

.PHONY: shell
shell:
	$(mkosi) shell

.PHONY: test
test:
	$(qemu) -accel kvm \
		-m 2048 \
		-kernel mkosi.builddir/fedipa.kernel \
		-initrd mkosi.builddir/fedipa.initramfs \
		-nographic \
		-display vnc=0.0.0.0:0 \
		-append "console=ttyS0"

.PHONY: git-submodule-init
git-submodule-init:
	git submodule init -- mkosi
	git submodule update -- mkosi
