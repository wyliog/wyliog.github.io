---
layout:       post
title:        "Docker 和 docker-compose安装"
subtitle:     "insall docker and docker-compose"
date:         2020-06-15 12:00:00
author:       "五柳"
header-mask:  0.3
catalog:      true
multilingual: true
tags:
    - jekyll
    - blog
    - docker
---

# 安装docker

通过阅读本文，你可以了解如何搭建docker，以及一些docker有基本原理

> 感谢你的阅读，如有任何问题可通过文章底部联系方式告知于我

---

<h2 id="catalog">目录</h2>

- [安装docker](#install_docker)
  - [linux系统](#install_docker_linux)
  - [windows系统](#install_docker_windows)
  - [官方文档](#docker_docs)
- [安装docker-compose](#install_docker_compose)
  - [linux系统](#install_docker_compose_linux)
  - [window系统](#install_docker_compose_win)
- [docker原理解析](#docker-principle)
- [一些最佳实践](#Best_Practices)



## 正文



<h3 id="install_docker">安装docker</h3>
> 为什么要用docker

- 隔离性强
- 可移植性高
- 轻量和高效
- 系统资源需求少
- 方便自动化集成部署


<div id="install_docker_linux">linux安装docker</div>


-  使用官方脚本安装
> 由于docker国外源安装很慢所以文章都将docker源修改为国内源，如果你在国外服务器安装可以不用修改源
```bash
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```
- 手动安装
```bash
# step 1: 安装依赖
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加docker源
# https://download.docker.com/linux/centos/docker-ce.repo 官方源
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 安装docker-ce
sudo yum -y install docker-ce
# Step 4: 开启Docker服务
sudo systemctl start docker
sudo systemctl enable docker
```

<div id="install_docker_linux">windows安装docker</div>

[点击这里](https://docs.docker.com/docker-for-windows/install/)

<div id="docker_docs">官方文档</div>

[点击这里](https://docs.docker.com/engine/install/centos/)

<h3 id="install_docker_compose">安装docker-compose</h3>

<div id="install_docker_compose_linux">linux安装</div>

- 获取docker-compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
- 修改权限
```bash
sudo chmod +x /usr/local/bin/docker-compose
```

<div id="install_docker_compose_win">windows安装</div>

[点击这里](https://docs.docker.com/docker-for-windows/install/)



没看错windows只需装一个docker-desktop即可

<h3 id="docker-principle">docker 原理解析</h3>

* https://www.huweihuang.com/article/docker/docker-commands-principle/
<h3 id="docker-principle">容器最佳实践</h3>

* https://martinliu.cn/posts/cloud-native-container-design/
* https://www.slideshare.net/luebken/container-patterns
* https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices
* http://docs.projectatomic.io/container-best-practices
* https://docs.openshift.com/enterprise/3.0/creating_images/guidelines.html
* https://www.usenix.org/system/files/conference/hotcloud16/hotcloud16_burns.pdf
* https://leanpub.com/k8spatterns/
* https://12factor.net






#### 您可以通过以下方式联系到我：
- 个人 Blog:  [willants.com](https://willants.com)
- 微信号:

![img](/img/wechat.jpg)


**[⬆ 返回顶部](#catalog)**
