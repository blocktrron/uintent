include $(TOPDIR)/rules.mk

PKG_NAME:=uintent-usteer
PKG_VERSION:=2023-08-26
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/uintent-usteer
	TITLE:=configure usteer via uitent
	PKGARCH:=all
	DEPENDS:=+uintent +usteer
endef

define Package/uintent-usteer/description
  uintent integration for the usteer daemon.
endef

define Build/Compile
endef

define Package/uintent-usteer/install
	$(CP) ./files/. $(1)/
endef

$(eval $(call BuildPackage,uintent-usteer))
