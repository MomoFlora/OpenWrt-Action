#!/bin/bash -e

# golang 1.26
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

# rust
rm -rf feeds/packages/lang/rust
git clone https://github.com/sbwml/packages_lang_rust feeds/packages/lang/rust

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node feeds/packages/lang/node -b packages-25.12

# luci-app-diskman
git clone https://github.com/sbwml/luci-app-diskman package/new/diskman --depth=1

# luci-app-filemanager
rm -rf feeds/luci/applications/luci-app-filemanager
git clone https://github.com/sbwml/luci-app-filemanager package/new/luci-app-filemanager

# luci-app-quickfile
git clone https://github.com/sbwml/luci-app-quickfile package/new/quickfile

# luci-app-airplay2
git clone https://github.com/sbwml/luci-app-airplay2 package/new/airplay2

# luci-app-webdav
git clone https://github.com/sbwml/luci-app-webdav package/new/luci-app-webdav

# ddns - fix boot
sed -i '/boot()/,+2d' feeds/packages/net/ddns-scripts/files/etc/init.d/ddns

# nlbwmon - disable syslog
sed -i 's/stderr 1/stderr 0/g' feeds/packages/net/nlbwmon/files/nlbwmon.init

# frpc
sed -i 's/procd_set_param stdout $stdout/procd_set_param stdout 0/g' feeds/packages/net/frp/files/frpc.init
sed -i 's/procd_set_param stderr $stderr/procd_set_param stderr 0/g' feeds/packages/net/frp/files/frpc.init
sed -i 's/stdout stderr //g' feeds/packages/net/frp/files/frpc.init
sed -i '/stdout:bool/d;/stderr:bool/d' feeds/packages/net/frp/files/frpc.init
sed -i '/stdout/d;/stderr/d' feeds/packages/net/frp/files/frpc.config
sed -i 's/env conf_inc/env conf_inc enable/g' feeds/packages/net/frp/files/frpc.init
sed -i "s/'conf_inc:list(string)'/& \\\\/" feeds/packages/net/frp/files/frpc.init
sed -i "/conf_inc:list/a\\\t\t\'enable:bool:0\'" feeds/packages/net/frp/files/frpc.init
sed -i '/procd_open_instance/i\\t\[ "$enable" -ne 1 \] \&\& return 1\n' feeds/packages/net/frp/files/frpc.init
curl -s $mirror/patch/frpc/luci-app-frpc/001-luci-app-frpc-hide-token.patch | patch -p1
curl -s $mirror/patch/frpc/luci-app-frpc/002-luci-app-frpc-add-enable-flag.patch | patch -p1

# natmap
sed -i 's/log_stdout:bool:1/log_stdout:bool:0/g;s/log_stderr:bool:1/log_stderr:bool:0/g' feeds/packages/net/natmap/files/natmap.init
pushd feeds/luci
    curl -s $mirror/patch/natmap/luci-app-natmap/0001-luci-app-natmap-add-default-STUN-server-lists.patch | patch -p1
popd

# samba4 - bump version
#rm -rf feeds/packages/net/samba4
#git clone https://$github/sbwml/feeds_packages_net_samba4 feeds/packages/net/samba4
# enable multi-channel
sed -i '/workgroup/a \\n\t## enable multi-channel' feeds/packages/net/samba4/files/smb.conf.template
sed -i '/enable multi-channel/a \\tserver multi channel support = yes' feeds/packages/net/samba4/files/smb.conf.template
# default config
sed -i 's/#aio read size = 0/aio read size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#aio write size = 0/aio write size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#create mask/create mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#directory mask/directory mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/0666/0644/g;s/0744/0755/g;s/0777/0755/g' feeds/luci/applications/luci-app-samba4/htdocs/luci-static/resources/view/samba4.js
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/samba.config
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/smb.conf.template

# SSRP & Passwall
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}
git clone https://github.com/MomoFlora/openwrt_helloworld package/new/helloworld

# openlist
git clone https://github.com/sbwml/luci-app-openlist2 package/new/openlist --depth=1

# qBittorrent
git clone https://github.com/sbwml/luci-app-qbittorrent package/new/qbittorrent --depth=1

# unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic package/new/luci-app-unblockneteasemusic --depth=1
sed -i 's/解除网易云音乐播放限制/网易云音乐解锁/g' package/new/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json

# Theme
git clone https://github.com/sbwml/luci-theme-argon -b openwrt-25.12 package/new/luci-theme-argon --depth=1
git clone https://github.com/eamonxg/luci-theme-aurora package/new/luci-theme-aurora --depth=1
git clone https://github.com/eamonxg/luci-app-aurora-config package/new/luci-app-aurora-config --depth=1
rm -rf package/new/luci-theme-aurora/root/etc/uci-defaults
sed -i 's/100/85/g' package/new/luci-app-aurora-config/root/usr/share/luci/menu.d/luci-app-aurora.json

# Mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/new/mosdns --depth=1

# OpenAppFilter
git clone https://github.com/sbwml/OpenAppFilter --depth=1 package/new/OpenAppFilter -b main

# iperf3
sed -i "s/D_GNU_SOURCE/D_GNU_SOURCE -funroll-loops/g" feeds/packages/net/iperf3/Makefile

# nlbwmon
sed -i 's/services/network/g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's/services/network/g' feeds/luci/applications/luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

# mentohust
git clone https://github.com/sbwml/luci-app-mentohust package/new/mentohust

# custom packages
rm -rf feeds/packages/utils/coremark
git clone https://github.com/sbwml/openwrt_pkgs package/new/custom --depth=1
rm -rf package/new/custom/ddns-scripts-aliyun

# frpc translation
sed -i 's,frp 服务器,Frp 服务器,g' feeds/luci/applications/luci-app-frps/po/zh_Hans/frps.po
sed -i 's,frp 客户端,Frp 客户端,g' feeds/luci/applications/luci-app-frpc/po/zh_Hans/frpc.po

# luci-app-sqm
rm -rf feeds/luci/applications/luci-app-sqm
git clone https://github.com/sbwml/luci-app-sqm feeds/luci/applications/luci-app-sqm

# unzip
rm -rf feeds/packages/utils/unzip
git clone https://github.com/sbwml/feeds_packages_utils_unzip feeds/packages/utils/unzip

# tcp-brutal
git clone https://github.com/sbwml/package_kernel_tcp-brutal package/kernel/tcp-brutal

# watchcat - clean config
true > feeds/packages/utils/watchcat/files/watchcat.config
