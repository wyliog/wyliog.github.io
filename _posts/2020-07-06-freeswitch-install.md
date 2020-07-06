---
layout:       post
title:        "Centos利用脚本快速安装vsftp"
subtitle:     vsftp install for script
date:         2020-07-06 12:00:00
author:       "五柳"
header-mask:  0.3
catalog:      true
multilingual: true
tags:
    - vsftp
    - ftp
---

通过阅读本文，你可以快速的在centos下搭建一个多用户的ftp server

> 感谢你的阅读，如有任何问题可通过文章底部联系方式告知于我

---

<h2 id="catalog">目录</h2>

- [准备安装脚本](#directory_1)
- [安装vsftp](#directory_2)
- [添加用户](#directory_3)



## 正文

<h3 id="directory_1">准备脚本</h3>

vi vsftp.sh
```
#!/bin/sh
#author: vim


users=/etc/vsftpd/vftpuser.txt    #账号配置文件
login=/etc/vsftpd/vftpuser.db    #账号数据库文件
generate_db="db_load -T -t hash -f $users $login"
virtual_user_config=/etc/vsftpd/vuser_conf
virtual_user_home=/opt/collection    #ftp根目录位置
guest_username=navi    #指定ftp权限账号

#Source function library
. /etc/rc.d/init.d/functions

install_vsftpd(){
setenforce 0
yum -y install db4-utils
yum -y install vsftpd
systemctl enable vsftpd

useradd -s /sbin/nologin ${guest_username}

mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
cat >/etc/vsftpd/vsftpd.conf<<EOF
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
pasv_enable=YES
pasv_min_port=60000
pasv_max_port=61000
xferlog_std_format=YES
listen=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES

chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list

pam_service_name=vsftpd
guest_enable=YES
guest_username=${guest_username}
user_config_dir=/etc/vsftpd/vuser_conf
allow_writeable_chroot=YES
EOF

mkdir /etc/vsftpd/vuser_conf
mkdir /etc/vsftpd/chroot_list


#i386 32位系统打开下列两行
#echo 'auth required pam_userdb.so db=/etc/vsftpd/vftpuser' > /etc/pam.d/vsftpd
#echo 'account required pam_userdb.so db=/etc/vsftpd/vftpuser' >> /etc/pam.d/vsftpd

#X64 64位系统打开下列两行
echo 'auth required /lib64/security/pam_userdb.so db=/etc/vsftpd/vftpuser' > /etc/pam.d/vsftpd
echo 'account required /lib64/security/pam_userdb.so db=/etc/vsftpd/vftpuser' >> /etc/pam.d/vsftpd

touch /etc/vsftpd/vftpuser.txt

systemctl restart vsftpd
}


add_user(){
not_enough_parameter=56
retval=0

if [ "$#" -ne 2 ]; then
    echo "usage:`basename $0` <useradd> <user_name> <password>."
    exit $not_enough_parameter
fi

if grep -q "$1" "$users"; then
   passwd=$(sed -n "/$1/{n;p;}" "$users")
   if [ "$passwd" = "$2" ]; then
       echo "the user $1 already exists."
       exit $retval
   else
       echo "updating $1's password ... "
       sed -i "/$1/{n;s/$passwd/$2/;}" "$users"
       eval "$generate_db"
       exit $retval
   fi
fi

for i in "$1" "$2"
do
    echo "$i" >> "$users"
done

eval "$generate_db"

cat >> "$virtual_user_config"/"$1" <<EOF
local_root=$virtual_user_home/$1
write_enable=YES
download_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
local_umask=022
EOF

mkdir -p "$virtual_user_home"/"$1"
chown $guest_username "$virtual_user_home"/"$1"

echo "==========$users============"
cat $users
}

case "$1" in
    'install')
      install_vsftpd
        ;;
    'useradd')
      add_user $2 $3
        ;;
    *)
    echo "usage: $0 {install|useradd}"
    exit 1
        ;;
esac

```
<h3 id="directory_2">安装vsftp</h3>

```
sh vsftp.sh install
```
<h3 id="directory_3">添加用户</h3>

```
sh vsftp.sh useradd username password
```

#### END



#### 您可以通过以下方式联系到我：
- 个人 Blog:  [willants.com](https://willants.com)
- 微信号:

![img](/img/wechat.jpg)


**[⬆ 返回顶部](#catalog)**
