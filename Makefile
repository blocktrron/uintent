ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
escape = '$(subst ','\'',$(1))'

ifeq ($(UINTENT_TARGET),)
$(error No Target set)
endif

include version.mk

UINTENT_DLDIR ?= dl
UINTENT_OPENWRT_DIR ?= openwrt
UINTENT_SCRIPTDIR ?= scripts
UINTENT_CONFIG_DIR ?= $(ROOT_DIR)/config

UINTENT_TARGET_LIST = $(subst -, ,$(UINTENT_TARGET))
UINTENT_PRITARGET = $(word 1,$(UINTENT_TARGET_LIST))
UINTENT_SUBTARGET = $(word 2,$(UINTENT_TARGET_LIST))

UINTENT_SDK_DIR = $(UINTENT_OPENWRT_DIR)/sdk-$(UINTENT_PRITARGET)-$(UINTENT_SUBTARGET)-$(OPENWRT_VERSION)
UINTENT_IMAGEBUILDER_DIR = $(UINTENT_OPENWRT_DIR)/imagebuilder-$(UINTENT_PRITARGET)-$(UINTENT_SUBTARGET)-$(OPENWRT_VERSION)

SDK_MAKE := $(MAKE) -C $(UINTENT_SDK_DIR)
IMAGEBUILDER_MAKE := $(MAKE) -C $(UINTENT_IMAGEBUILDER_DIR)

UINTENT_VARS = UINTENT_DLDIR UINTENT_OPENWRT_DIR UINTENT_SCRIPTDIR UINTENT_CONFIG_DIR UINTENT_PRITARGET UINTENT_SUBTARGET OPENWRT_VERSION OPENWRT_DOWNLOAD_URL
unexport $(UINTENT_VARS)
UINTENT_ENV = $(foreach var,$(UINTENT_VARS),$(var)=$(call escape,$($(var))))

UINTENT_BOARD_LIST := "$(shell $(UINTENT_ENV) $(ROOT_DIR)/scripts/target-profile-list.sh)"

all:

	# Create Build-key
	@$(UINTENT_SDK_DIR)/staging_dir/host/bin/usign -G -p $(UINTENT_OPENWRT_DIR)/build.pub -s $(UINTENT_OPENWRT_DIR)/build.priv
	# Compile with SDK
	@rm -f $(UINTENT_SDK_DIR)/.config
	@cp $(UINTENT_SDK_DIR)/feeds.conf.default $(UINTENT_SDK_DIR)/feeds.conf
	@echo "src-link uintent $(ROOT_DIR)/package" >> $(UINTENT_SDK_DIR)/feeds.conf
	@$(UINTENT_SDK_DIR)/scripts/feeds update uintent
	@$(UINTENT_SDK_DIR)/scripts/feeds install -a
	@echo 'CONFIG_UINTENT_CONFIG_DIR="$(UINTENT_CONFIG_DIR)"' > $(UINTENT_SDK_DIR)/.config
	$(SDK_MAKE) defconfig
	$(SDK_MAKE) package/uintent/clean
	$(SDK_MAKE) package/uintent-config/clean
	$(SDK_MAKE) package/uintent/compile
	$(SDK_MAKE) package/index BUILD_KEY="$(ROOT_DIR)/$(UINTENT_OPENWRT_DIR)/build.priv"
	# Build with ImageBuilder
	@ln -fs "$(ROOT_DIR)/$(UINTENT_OPENWRT_DIR)/build.pub" "$(UINTENT_IMAGEBUILDER_DIR)/keys/$$($(UINTENT_IMAGEBUILDER_DIR)/staging_dir/host/bin/usign -p $(UINTENT_OPENWRT_DIR)/build.pub -F)"
	@$(UINTENT_ENV) scripts/imagebuilder-add-repo.sh
	@for n in "$(UINTENT_BOARD_LIST)"; do \
		$(IMAGEBUILDER_MAKE) image PROFILE="$$n" PACKAGES="uintent uintent-config"; \
	done
	@$(UINTENT_ENV) scripts/copy-output.sh


download:
	@mkdir -p $(UINTENT_DLDIR) || true
	@mkdir -p $(UINTENT_OPENWRT_DIR) || true
	@$(UINTENT_ENV) scripts/download-target.sh

clean:
	@rm -rf openwrt
	@rm -rf dl
