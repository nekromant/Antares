#directory i should grab the source from
SRCDIR?=.
#the directory i should dump .o to
OBJDIR?=.
#top level directory, where .config is
TOPDIR?=.
#antares directory where all the scripts are
ANTARES_DIR?=$(TOPDIR)
#temporary dir for autogenerated stuff and other such shit
TMPDIR?=tmp

ANTARES_DIR:=$(abspath $(ANTARES_DIR))
TMPDIR:=$(abspath $(TMPDIR))
TOPDIR:=$(abspath $(TOPDIR))

Kbuild:=Kconfig
obj:=$(OBJDIR)/kconfig
src:=$(SRCDIR)/kconfig
Kconfig:=$(SRCDIR)/kcnf
KVersion:=./version.kcnf

PHONY+=deftarget deploy build collectinfo clean
MAKEFLAGS:=-r

IMAGENAME=$(call unquote,$(CONFIG_IMAGE_DIR))/$(call unquote,$(CONFIG_IMAGE_FILENAME))

export SRCDIR TMPDIR IMAGENAME ARCH TOPDIR ANTARES_DIR

-include $(TOPDIR)/.config
-include $(ANTARES_DIR)/.version

.DEFAULT_GOAL := $(subst ",, $(CONFIG_MAKE_DEFTARGET))

include $(ANTARES_DIR)/make/host.mk
include $(TMPDIR)/arch.mk
include $(ANTARES_DIR)/make/Makefile.lib
-include $(ANTARES_DIR)/src/arch/$(ARCH)/arch.mk

ifeq ($(ANTARES_DIR),$(TOPDIR))
$(info $(tb_red))
$(info Please, do not run make in the antares directory)
$(info Use an out-of-tree project directory instead.)
$(info Have a look at the documentation on how to do that)
$(info $(col_rst))
$(error aborted)
endif



ifeq ($(CONFIG_TOOLCHAIN_GCC),y)
include $(ANTARES_DIR)/toolchains/gcc.mk
endif

include $(ANTARES_DIR)/make/Makefile.collect

-include src/arch/$(ARCH)/arch.mk

include $(ANTARES_DIR)/kconfig/kconfig.mk


.SUFFIXES:

clean-y:="$(TMPDIR)" "$(TOPDIR)/build" "$(TOPDIR)/include/generated" "$(CONFIG_IMAGE_DIR)"

clean:  
	-$(SILENT_CLEAN) rm -Rf $(clean-y)

mrproper: clean
	-$(SILENT_MRPROPER) rm -Rf $(TOPDIR)/kconfig 
	$(Q)rm -f $(TOPDIR)/antares
	$(Q)rm -Rf $(TOPDIR)/include/config
	$(Q)rm -f $(TOPDIR)/include/arch

distclean: mrproper

build: collectinfo silentoldconfig collectinfo $(BUILDGOALS)

deploy: build
	$(Q)$(MAKE) -f $(SRCDIR)/make/Makefile.deploy $(call unquote,$(CONFIG_DEPLOY_DEFTARGET))
	@echo "Your Antares firmware is now deployed"

deploy-%: build
	$(Q)$(MAKE) -f $(SRCDIR)/make/Makefile.deploy $*
	@echo "Your Antares firmware is now deployed"
	$(Q)$(MAKE) -f $(SRCDIR)/make/Makefile.deploy post

deploy-help:
	make -f make/Makefile.deploy help

.PHONY: $(PHONY)
