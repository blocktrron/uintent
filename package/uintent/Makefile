include $(TOPDIR)/rules.mk

PKG_NAME:=uintent
PKG_VERSION:=2023-02-05
PKG_RELEASE:=1

PKG_MAINTAINER:=Martin Weinelt <hexa@darmstadt.ccc.de>

include $(INCLUDE_DIR)/package.mk

define Package/uintent
	TITLE:=Intent-based Access-Point configuration
	PKGARCH:=all
	DEPENDS:=+luaposix +libiwinfo-lua +libuci-lua +lua-cjson +uintent-config
endef

define Package/uintent/description
	Intent-based Access-Point configuration
endef

define Build/Compile
endef

define Package/uintent/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/zzz-reconfigure $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/lib/lua/uintent
	$(CP) ./files/usr/lib/lua/uintent/simple-uci.lua $(1)/usr/lib/lua/uintent
	$(CP) ./files/usr/lib/lua/uintent/util.lua $(1)/usr/lib/lua/uintent
	$(CP) ./files/usr/lib/lua/uintent/wireless.lua $(1)/usr/lib/lua/uintent
	$(INSTALL_DIR) $(1)/lib/setup
	$(CP) ./files/lib/uintent $(1)/lib
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/reconfigure $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/lib/uintent
	$(INSTALL_BIN) ./files/usr/lib/uintent/label_mac.sh $(1)/usr/lib/uintent/label_mac.sh
endef

$(eval $(call BuildPackage,uintent))
