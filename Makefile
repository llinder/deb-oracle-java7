#!/usr/bin/make -f
# -*- makefile -*-

# START values that need to be updated for each Java release

version		:= 7u9
java_sha256_map	:= \
	amd64=1b39fe2a3a45b29ce89e10e59be9fbb671fb86c13402e29593ed83e0b419c8d7 \
	i386=47e86ceb7f59c821a8d0c54f34530bca84e10c1849ed46da7f4fdb5f621bc8d6

# END

distribution    := $(shell lsb_release -is)
distrelease     := $(shell lsb_release -cs)

DEB_HOST_ARCH   ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)

arch_map        := amd64=x64 i386=i586
archdir_map     := amd64=amd64 i386=i386

arch            := $(strip $(patsubst $(DEB_HOST_ARCH)=%, %, \
			$(filter $(DEB_HOST_ARCH)=%, $(arch_map))))
archdir         := $(strip $(patsubst $(DEB_HOST_ARCH)=%, %, \
			$(filter $(DEB_HOST_ARCH)=%, $(archdir_map))))

java_sha256	:= $(strip $(patsubst $(DEB_HOST_ARCH)=%, %, \
			$(filter $(DEB_HOST_ARCH)=%, $(sha256_map))))
java_filename	:= jdk-$(version)-linux-$(arch).tar.gz
java_url	:= http://download.oracle.com/otn-pub/java/jdk/7u9-b05/$(java_filename)

jce_sha256	:= 7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d
jce_filename	:= UnlimitedJCEPolicyJDK7.zip
jce_url		:= http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip

build: download-java download-jce

download-java:
	wget --progress=bar:force -t 2 --continue -O $(java_filename) \
		--header "Cookie: gpw_e24=h" $(java_url) || \
		echo 'Java download not found'
	
	@echo $(java_sha256) $(java_filename) sha256sum -c || \
		( echo 'Java SHA256 check failed' && rm $(java_filename); exit 1 )

download-jce:
	wget --progress=bar:force -t 2 --continue -O $(jce_filename) \
		--header "Cookie: gpw_e24=h" $(jce_url) || \
		echo 'JCE download not found'
	
	@echo $(jce_sha256) $(jce_filename) sha256sum -c || \
		( echo 'JCE SHA256 check failed' && rm $(jce_filename); exit 1 )

clean:
	rm -f $(java_filename)
	rm -f $(jce_filename)

.PHONY: download-java download-jce download clean


