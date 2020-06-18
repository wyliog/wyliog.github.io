---
layout:       post
title:        "windows 激活服务器搭建"
subtitle:     "windows kms server setup"
date:         2020-06-14 12:00:00
author:       "五柳"
header-mask:  0.3
catalog:      true
multilingual: true
tags:
    - registry
    - tools
    - windows
---

# Windows 激活服务器搭建

通过阅读本文，可以实现快速构建一个windows激活服务器，用于激活windows/office系列产品。

> 感谢你的阅读，如有任何问题可通过文章底部联系方式告知于我

---

<h2 id="catalog">目录</h2>

- [安装docker/docker-compose](#docker_install)
- [构建激活服务器](#build_registry_server)
- [激活你的服务器](#build_server)
  - [windows](#registry_windows)
  - [office](#registry_office)


## 正文

<h3 id="docker_install">安装docker/docker-compose</h3>

参照我这篇文章:

[Docker 和 docker-compose安装](/2020/06/18/install-docker-dockercompose/)


<h3 id="build_registry_server">构建激活服务器</h3>


1. 创建docker-compose文件
vi docker-compose.yaml
```yaml
version: "3.7"
services:
  vlmcsd:
    image:  mikolatero/vlmcsd
    ports:
      - "1688:1688"
    restart: always
```
2. 启动服务
```bash
docker-compose up -d
```

3. 放行防火墙
```bash
firewall-cmd --zone=public --add-port=1688/tcp --permanent
```

<h3 id="build_server">激活你的服务器</h3>

---

首先找到您要激活的key

- [Windows](https://docs.microsoft.com/zh-cn/windows-server/get-started/kmsclientkeys)
- [Office 2019 & Office 2016](https://docs.microsoft.com/en-us/DeployOffice/vlactivation/gvlks)
- [Office 2013](https://technet.microsoft.com/zh-cn/library/dn385360.aspx)
- [Office 2010](https://technet.microsoft.com/zh-cn/library/ee624355(v=office.14).aspx)

<h4 id="registry_windows">激活windows系列</h4>

```bat
#卸载激活码
slmgr.vbs -upk
#安装对应版本激活码
slmgr.vbs -ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
#设置激活服务器，可将"xx.xx.xx.xx"换成自己对应的服务器IP或者域名
slmgr.vbs -skms xx.xx.xx.xx
slmgr.vbs -ato
slmgr.vbs -dlv
```
<h4 id="registry_office">激活Office系列</h4>

```bat
cd C:\Program Files (x86)\Microsoft Office\Office16
# 将xx.xx.xx.xx换成你的kms服务器地址
cscript ospp.vbs /sethst:xx.xx.xx.xx
# 激活
slmgr /ipk XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99
cscript ospp.vbs /act
# 查看状态
cscript ospp.vbs /dstatus
```
小工具office pro-vol
```bat
@ECHO OFF&PUSHD %~DP0
 
setlocal EnableDelayedExpansion&color 3e & cd /d "%~dp0"
title office2016 retail转换vol版
 
%1 %2
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :runas","","runas",1)(window.close)&goto :eof
:runas
 
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16"
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16"
 
:WH
cls
echo.
echo                         选择需要转化的office版本序号
echo.
echo --------------------------------------------------------------------------------                                                         
echo                 1. 零售版 Office Pro Plus 2016 转化为VOL版
echo.
echo                 2. 零售版 Office Visio Pro 2016 转化为VOL版
echo.
echo                 3. 零售版 Office Project Pro 2016 转化为VOL版
echo.
echo. --------------------------------------------------------------------------------
                                                        
set /p tsk="请输入需要转化的office版本序号【回车】确认（1-3）: "
if not defined tsk goto:err
if %tsk%==1 goto:1
if %tsk%==2 goto:2
if %tsk%==3 goto:3
 
:err
goto:WH
 
:1
cls
 
echo 正在重置Office2016零售激活...
cscript ospp.vbs /rearm
 
echo 正在安装 KMS 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
 
echo 正在安装 MAK 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
 
echo 正在安装 KMS 密钥...
cscript ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99
 
goto :e
 
:2
cls
 
echo 正在重置Visio2016零售激活...
cscript ospp.vbs /rearm
 
echo 正在安装 KMS 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\visio???vl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
 
echo 正在安装 MAK 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\visio???vl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
 
echo 正在安装 KMS 密钥...
cscript ospp.vbs /inpkey:PD3PC-RHNGV-FXJ29-8JK7D-RJRJK
 
goto :e
 
:3
cls
 
echo 正在重置Project2016零售激活...
cscript ospp.vbs /rearm
 
echo 正在安装 KMS 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\project???vl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
 
echo 正在安装 MAK 许可证...
for /f %%x in ('dir /b ..\root\Licenses16\project???vl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
 
echo 正在安装 KMS 密钥...
cscript ospp.vbs /inpkey:YG9NW-3K39V-2T3HJ-93F3Q-G83KT
 
goto :e
 
:e
echo.
echo 转化完成，按任意键退出！
pause >nul
exit
```



#### 您可以通过以下方式联系到我：
- 个人 Blog:  [willants.com](https://willants.com)
- 微信号:

![img](/img/wechat.jpg)


**[⬆ 返回顶部](#catalog)**
