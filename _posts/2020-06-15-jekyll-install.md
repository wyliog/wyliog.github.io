---
layout:       post
title:        "Jekyll 构建一个属于你的博客"
subtitle:     "Jekyll build your own blog"
date:         2020-06-18 12:00:00
author:       "五柳"
header-mask:  0.3
catalog:      true
multilingual: true
tags:
    - jekyll
    - blog
---

# Jekyll 搭建博客

通过阅读本文，你可以学会如何基于Jekyll 搭建一个属于你自己的博客

> 感谢你的阅读，如有任何问题可通过文章底部联系方式告知于我

---

<h2 id="catalog">目录</h2>

- [注册github账号](#registry_github)
- [创建一个仓库](#create_github_repo)
- [基于docker安装jeyll](#build_registry_server)
  - [安装docker/docker-compose](#install_docker)
  - [clone一个属于你的主题](#clone_theme)
  - [启动docker-compose](#start_docker_compose)
- [开始写你的第一篇文章](#write_frist_blog)
- [push到github](#push_to_github)


## 正文

<h3 id="registry_github">注册github账号</h3>

> 想什么呢？能折腾到这里了还写注册教程，想多了。

点击[注册](https://github.com/),剩下的自己琢磨


<h3 id="create_github_repo">创建一个仓库</h3>

> 注意仓库名称一定要是用户名+github.io比如我的就是wyliog.github.io

创建仓库参考：https://help.github.com/cn/github/getting-started-with-github/create-a-repo

配置一个个性域名参考: https://help.github.com/cn/github/working-with-github-pages/configuring-a-custom-domain-for-your-github-pages-site


<h3 id="build_registry_server">创建基于docker安装jeyll</h3>

> 为什么要基于docker安装而不是直接安装到主机上呢？借用一句流行语，lz愿意！ 开个玩笑，docker安装可以有效解决环境依赖问题，并且跨平台使用，不用过多关注环境依赖安装，其实一开始装很多东西都是折腾的死去活来，发现是主机依赖问题，然后卸载又卸载不干净，是不是有重装系统的冲动。

<div id="install_docker">安装docker/docker-compose</div>

参照我这篇文章:

[Docker 和 docker-compose安装](/2020/06/15/install-docker-dockercompose/)

<div id="clone_theme">clone一个主题</div>

- 比如我用的这个主题： https://github.com/Huxpro/huxpro.github.io
- 这是我的主题（做了一些删除）：https://github.com/wyliog/wyliog.github.io

<div id="start_docker_compose">启动docker-compose</div>

```bash
cd wyliog.github.io
docker-compose up -d
```

<h3 id="write_frist_blog">开始写你的第一篇文章</h3>

- 在_posts下新建一个md文件

> 格式:YYYY-MM-DD-NAME.md


- 写上文章标题

```
layout:       post
title:        "Jekyll 构建一个属于你的博客"
subtitle:     "Jekyll build your own blog"
date:         2020-06-18 12:00:00
author:       "五柳"
header-mask:  0.3
catalog:      true
multilingual: true
tags:
    - jekyll
    - blog
```

最后开始用markdown开启你的创作之旅吧





---



#### 您可以通过以下方式联系到我：
- 个人 Blog:  [willants.com](https://willants.com)
- 微信号:

![img](/img/wechat.jpg)


**[⬆ 返回顶部](#catalog)**
