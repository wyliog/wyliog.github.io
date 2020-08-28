---
layout:       post
title:        "K8s下利用traefik实现负载均衡"
subtitle:     grpc lb with traefik
date:         2020-08-28 15:00:00
author:       "五柳"
header-mask:  0.3
catalog:      true
multilingual: true
tags:
    - grpc
    - traefik
---

<h2 id="catalog">目录</h2>
- [什么是GRPC?](#directory)
- [GRPC常见的LB实现方式](#directory_1)
    - [代理模式](#directory_1.1)  
    - [客户端模式](#directory_1.2)
    - [优劣势比较](#directory_1.3)
    - [最佳实践](#directory_1.4)
- [利用traefik实现LB实践](#directory_2)
    - [创建service](#directory_2.1)
    - [创建ingress](#directory_2.2)
    - [验证](#directory_2.3)




## 正文

<h3 id="directory">什么是GRPC</h3>

gRPC 是一个高性能、通用的开源RPC框架，其由 Google 主要面向移动应用开发并基于HTTP/2 协议标准而设计，基于 ProtoBuf(Protocol Buffers) 序列化协议开发，gRPC有很多优点，例如

- 二进制协议(HTTP/2)
- 同一个连接可以复用多个请求
- http 头部压缩
- 拥有丰富的服务和消息定义
- 支持众多开发语言

<h3 id="directory_1">GRPC常见的LB实现方式</h3>
<h5 id="directory_1.1">proxy</h5>
client 将请求发送给lb，之后lb根据调度算法将请求分配给后端，实现公平分配
整体架构如下:
![img](/img/proxy.png)
<h5 id="directory_1.2">client side</h5>
由客户端来维护负载均衡，前提是需要知道每个服务端的真实地址，通过客户端自定义轮训策略实现负载均衡

![img](/img/client-side.png)
<h5 id="directory_1.3">优劣势比较</h5>

![img](/img/iShot2020-08-28PM03.56.54.png)


<h5 id="directory_1.3">最佳实践</h5>

![img](/img/iShot2020-08-28PM03.57.38.png)


<h3 id="directory_2">利用traefik实现LB实践</h3>

**注意，才在测试阶段，不确保生产环境可用**

<h5 id="directory_2.1">创建service</h5>

```yamlex
apiVersion: v1
kind: Service
metadata:
  name: testing-voice-asr
  labels:
    app.kubernetes.io/name: testing-voice
    helm.sh/chart: testing-voice-10.0.1
    app.kubernetes.io/instance: testing-voice
    app.kubernetes.io/version: "v2.1.1"
    app.kubernetes.io/managed-by: Helm
spec:
  clusterIP: None
  ports:
    - port: 50000
      targetPort: 50000
      protocol: TCP
      name: http-grpc-asr
    - port: 50001
      targetPort: 50001
      protocol: TCP
      name: http-asr
  selector:
    role: asr
    app.kubernetes.io/name: testing-voice
    app.kubernetes.io/instance: testing-voice

```

<h5 id="directory_2.2">创建ingress</h5>

注意添加: `ingress.kubernetes.io/protocol: h2c`


```yamlex

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: testing-voice-asr
  labels:
    app.kubernetes.io/name: testing-voice
    helm.sh/chart: testing-voice-10.0.1
    app.kubernetes.io/instance: testing-voice
    app.kubernetes.io/version: "v2.1.1"
    app.kubernetes.io/managed-by: Helm
  annotations:
    ingress.kubernetes.io/protocol: h2c
    kubernetes.io/ingress.class: traefik
spec:
  tls:
    - hosts:
        - "navinter-asr-dev01.fano.ai"
      secretName: vad-cert
  rules:
    - host: "navinter-asr-dev01.fano.ai"
      http:
        paths:
          - path: /
            backend:
              serviceName: testing-voice-asr
              servicePort: 50000

```
<h5 id="directory_2.3">验证</h5>
- 查看traefik 是否升级协议

![img](/img/iShot2020-08-28PM04.48.24.png)

- 通过client 循环发送请求，查看service 请求情况



**参考资料**

[https://grpc.io/blog/grpc-load-balancing/](https://grpc.io/blog/grpc-load-balancing/)

[https://colobu.com/2017/03/25/grpc-naming-and-load-balance/](https://colobu.com/2017/03/25/grpc-naming-and-load-balance/)
#### END



#### 您可以通过以下方式联系到我：
- 个人 Blog:  [willants.com](https://willants.com)


**[⬆ 返回顶部](#catalog)**
