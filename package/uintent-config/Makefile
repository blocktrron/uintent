include $(TOPDIR)/rules.mk

PKG_NAME:=uintent-config
PKG_VERSION:=2023-02-05
PKG_RELEASE:=1

UINTENT_CONFIG_DIR = $(call qstrip,$(CONFIG_UINTENT_CONFIG_DIR))

include $(INCLUDE_DIR)/package.mk

define Package/uintent-config
  TITLE:=Site-specific files of Gluon
  PKGARCH:=all
endef

define Package/uintent-config/config
config UINTENT_CONFIG_DIR
	string "uintent config directory"
	depends on PACKAGE_uintent-config
	default ""

endef

define Build/Compile
	cp -R $(UINTENT_CONFIG_DIR)/*  $(PKG_BUILD_DIR)/config/
endef

define Package/uintent-config/install
	$(INSTALL_DIR) $(1)/lib/uintent/config
	$(CP) $(PKG_BUILD_DIR)/config/* $(1)/lib/uintent/config
endef

$(eval $(call BuildPackage,uintent-config))
