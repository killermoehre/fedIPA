ifeq ($(UID),0)
	mkosi = ./mkosi/mkosi
	qemu = qemu-system-x86_64
else
	mkosi = sudo ./mkosi/mkosi
	qemu = sudo qemu-system-x86_64
endif

.PHONY: all
all: git-submodule-init clean build

.PHONY: clean
clean:
	$(mkosi) clean

.PHONY: build
build:
	$(mkosi) build

.PHONY: shell
shell:
	$(mkosi) shell

.PHONY: test
test:
	$(qemu) -accel kvm \
		-m 1024 \
		-kernel mkosi.builddir/tinyipa.kernel \
		-initrd mkosi.builddir/tinyipa.initramfs \
		-nographic \
		-display vnc=0.0.0.0:0 \
		-append "console=ttyS0 rd.shell rd.systemd.debug_shell systemd.debug_shell"

.PHONY: git-submodule-init
git-submodule-init:
	git submodule init -- mkosi
	git submodule update -- mkosi