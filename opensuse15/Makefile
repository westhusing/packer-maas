PACKER ?= packer
ISO ?= openSUSE-Leap-15.4-CR-DVD-x86_64-Build32.1-Media.iso

.PHONY: all clean

all: opensuse15.tar.gz

opensuse15.tar.gz: clean
	sudo ${PACKER} init opensuse.pkr.hcl && sudo PACKER_LOG=1 ${PACKER} build -var "opensuse15_iso_path=${ISO}" -on-error=ask opensuse.pkr.hcl
	reset

clean:
	sudo ${RM} -rf output-opensuse15 opensuse15.tar.gz

lint:
	packer validate .
	packer fmt -check -diff .

format:
	packer fmt .
