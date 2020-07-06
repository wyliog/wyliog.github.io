---
layout:       post
title:        "Freeswitch docker-compose安装"
subtitle:     Freeswitch docker-compose install
date:         2020-07-06 14:00:00
author:       "五柳"
header-mask:  0.3
catalog:      true
multilingual: true
tags:
    - vsftp
    - ftp
---

通过阅读本文，你可以快速的基于docker-compose启动一个freeswitch

> 感谢你的阅读，如有任何问题可通过文章底部联系方式告知于我

---

<h2 id="catalog">目录</h2>

- [freeswitch简介](#directory_1)
- [安装freeswitch](#directory_2)
- [验证](#directory_3)



## 正文

<h3 id="directory_1">freeswitch简介</h3>
 FreeSWITCH 是一个电话的软交换解决方案，包括一个软电话和软交换机用以提供语音和聊天的产品驱动。FreeSWITCH 可以用作交换机引擎、PBX、多媒体网关以及多媒体服务器等。

<h3 id="directory_2">基于docker-compose安装freeswitch</h3>

1. 懒人方法

```
git clone https://github.com/wyliog/freeswitch-docker.git
cd freeswitch-docker
vi docker-compose.yml
version: '2'
services:
   freeswitch:
     hostname: freeswitch
     container_name: freeswitch
     network_mode: "host"
     restart: always
     #build: ./  #注释掉这里
     mage: wyliog/freeswitch #打开这里
     command: freeswitch
     logging:
       options:
         max-size: 10m
     volumes:
      - ./conf:/etc/freeswitch
     tty: true
```

启动freeswitch

```
docker-compose up -d
```

2. 手动制作镜像
创建文件夹

```
mkdir freeswitch-docker
cd freeswitch-docker
```

创建dockerfile

```
FROM centos:7
COPY ./modules.conf /modules.conf
RUN yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release  https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm&& \
yum install -y git alsa-lib-devel autoconf automake bison broadvoice-devel bzip2 curl-devel libdb4-devel e2fsprogs-devel erlang flite-devel g722_1-devel gcc-c++ gdbm-devel gnutls-devel ilbc2-devel ldns-devel libcodec2-devel libcurl-devel libedit-devel libidn-devel libjpeg-devel libmemcached-devel libogg-devel libsilk-devel libsndfile-devel libtheora-devel libtiff-devel libtool libuuid-devel libvorbis-devel libxml2-devel lua-devel lzo-devel mongo-c-driver-devel ncurses-devel net-snmp-devel openssl-devel opus-devel pcre-devel perl perl-ExtUtils-Embed pkgconfig portaudio-devel postgresql-devel python-devel python-devel soundtouch-devel speex-devel sqlite-devel unbound-devel unixODBC-devel wget which yasm zlib-devel libshout-devel libmpg123-devel lame-devel rpm-build libX11-devel libyuv-devel ffmpeg ffmpeg-devel && \
yum-builddep -y freeswitch 

RUN yum install -y yum-plugin-ovl centos-release-scl rpmdevtools yum-utils && \
yum install -y devtoolset-8 && \
scl enable devtoolset-8 'bash' && \
cd /usr/local/src && \
git clone -b v1.10 https://github.com/signalwire/freeswitch.git freeswitch && \
cd /usr/local/src/freeswitch && cp -f  /modules.conf modules.conf &&  \
./bootstrap.sh -j && \
./configure --enable-portable-binary \
            --prefix=/usr --localstatedir=/var --sysconfdir=/etc \
            --with-gnu-ld --with-python --with-erlang --with-openssl \
            --enable-core-odbc-support --enable-zrtp && \
make && \
make -j install && \
make -j cd-sounds-install && \
make -j cd-moh-install

CMD ["/usr/bin/freeswitch","-nonat"]
```

创建module conf文件，可根据需要手动注释或者增加

```
#applications/mod_abstraction
applications/mod_av
#applications/mod_avmd
#applications/mod_bert
#applications/mod_blacklist
applications/mod_callcenter
#applications/mod_cidlookup
#applications/mod_cluechoo
applications/mod_commands
applications/mod_conference
#applications/mod_curl
#applications/mod_cv
applications/mod_db
#applications/mod_directory
#applications/mod_distributor
applications/mod_dptools
#applications/mod_easyroute
applications/mod_enum
applications/mod_esf
#applications/mod_esl
applications/mod_expr
applications/mod_fifo
#applications/mod_fsk
applications/mod_fsv
applications/mod_hash
#applications/mod_hiredis
applications/mod_httapi
#applications/mod_http_cache
#applications/mod_ladspa
#applications/mod_lcr
#applications/mod_memcache
#applications/mod_mongo
#applications/mod_mp4
#applications/mod_mp4v2
#applications/mod_nibblebill
#applications/mod_oreka
#applications/mod_osp
#applications/mod_prefix
#applications/mod_rad_auth
#applications/mod_redis
#applications/mod_rss
applications/mod_signalwire
applications/mod_sms
#applications/mod_sms_flowroute
#applications/mod_snapshot
#applications/mod_snom
#applications/mod_sonar
#applications/mod_soundtouch
applications/mod_spandsp
#applications/mod_spy
#applications/mod_stress
#applications/mod_translate
applications/mod_valet_parking
#applications/mod_video_filter
#applications/mod_vmd
applications/mod_voicemail
#applications/mod_voicemail_ivr
#asr_tts/mod_cepstral
#asr_tts/mod_flite
#asr_tts/mod_pocketsphinx
asr_tts/mod_tts_commandline
asr_tts/mod_unimrcp
codecs/mod_amr
#codecs/mod_amrwb
codecs/mod_b64
#codecs/mod_bv
#codecs/mod_clearmode
#codecs/mod_codec2
#codecs/mod_com_g729
#codecs/mod_dahdi_codec
codecs/mod_g723_1
codecs/mod_g729
codecs/mod_h26x
#codecs/mod_ilbc
#codecs/mod_isac
#codecs/mod_mp4v
codecs/mod_opus
#codecs/mod_sangoma_codec
#codecs/mod_silk
#codecs/mod_siren
#codecs/mod_theora
#databases/mod_mariadb
databases/mod_pgsql
dialplans/mod_dialplan_asterisk
#dialplans/mod_dialplan_directory
dialplans/mod_dialplan_xml
#directories/mod_ldap
#endpoints/mod_alsa
#endpoints/mod_dingaling
#endpoints/mod_gsmopen
#endpoints/mod_h323
#endpoints/mod_khomp
endpoints/mod_loopback
#endpoints/mod_opal
#endpoints/mod_portaudio
endpoints/mod_rtc
#endpoints/mod_rtmp
endpoints/mod_skinny
endpoints/mod_sofia
endpoints/mod_verto
#event_handlers/mod_amqp
event_handlers/mod_cdr_csv
#event_handlers/mod_cdr_mongodb
#event_handlers/mod_cdr_pg_csv
event_handlers/mod_cdr_sqlite
#event_handlers/mod_erlang_event
#event_handlers/mod_event_multicast
event_handlers/mod_event_socket
#event_handlers/mod_fail2ban
#event_handlers/mod_format_cdr
#event_handlers/mod_json_cdr
#event_handlers/mod_radius_cdr
#event_handlers/mod_odbc_cdr
#event_handlers/mod_kazoo
#event_handlers/mod_rayo
#event_handlers/mod_smpp
#event_handlers/mod_snmp
#event_handlers/mod_event_zmq
#formats/mod_imagick
formats/mod_local_stream
formats/mod_native_file
formats/mod_png
#formats/mod_portaudio_stream
#formats/mod_shell_stream
#formats/mod_shout
formats/mod_sndfile
#formats/mod_ssml
formats/mod_tone_stream
#formats/mod_vlc
#formats/mod_opusfile
#languages/mod_basic
#languages/mod_java
languages/mod_lua
#languages/mod_managed
#languages/mod_perl
languages/mod_python
#languages/mod_v8
#languages/mod_yaml
loggers/mod_console
#loggers/mod_graylog2
loggers/mod_logfile
loggers/mod_syslog
#loggers/mod_raven
#say/mod_say_de
say/mod_say_en
#say/mod_say_es
#say/mod_say_es_ar
#say/mod_say_fa
#say/mod_say_fr
#say/mod_say_he
#say/mod_say_hr
#say/mod_say_hu
#say/mod_say_it
#say/mod_say_ja
#say/mod_say_nl
#say/mod_say_pl
#say/mod_say_pt
#say/mod_say_ru
#say/mod_say_sv
#say/mod_say_th
#say/mod_say_zh
#timers/mod_posix_timer
#timers/mod_timerfd
xml_int/mod_xml_cdr
#xml_int/mod_xml_curl
#xml_int/mod_xml_ldap
#xml_int/mod_xml_radius
xml_int/mod_xml_rpc
xml_int/mod_xml_scgi

#../../libs/freetdm/mod_freetdm

## Experimental Modules (don't cry if they're broken)
#../../contrib/mod/xml_int/mod_xml_odbc
```

执行docker build生成镜像,根据网速情况预计需要20-40min

```
docker build -t freeswitch-docker:v1.10 .
```

创建docker-compose文件

```
version: '2'
services:
   freeswitch:
     hostname: freeswitch
     container_name: freeswitch
     network_mode: "host"
     restart: always
    # build: ./
     image: wyliog/freeswitch
     command: freeswitch
     logging:
       options:
         max-size: 10m
     volumes:
      - ./conf:/etc/freeswitch
     tty: true
```

获取conf文件

[copy这里的conf文件](https://github.com/signalwire/freeswitch/tree/master/conf/insideout)

```
git clone -b v1.xx https://github.com/signalwire/freeswitch.git
```

启动`docker-compose up -d`

<h3 id="directory_3">验证</h3>

下载linphone 拨号测试


#### END



#### 您可以通过以下方式联系到我：
- 个人 Blog:  [willants.com](https://willants.com)
- 微信号:

![img](/img/wechat.jpg)


**[⬆ 返回顶部](#catalog)**
