# Tailscale Derper

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/zhz8888/derper/build.yml)

## 简介



## 快速开始

- Docker命令

```bash
docker run -d \
  --name derper \
  -e TZ=Asia/Shanghai \
  -e DERP_CERT_MODE=manual \
  -e DERP_ADDR=:10088 \
  -e DERP_HTTP_PORT=-1 \
  -e DERP_STUN_PORT=10089 \
  -e DERP_DOMAIN=your.domain.com \
  -e DERP_VERIFY_CLIENTS=true \
  -v /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock \
  -v /your/certs/path:/app/certs \
  -p 10088:10088 \
  -p 10089:10089/udp \
  --restart always \
  zhz1021/derper
```

- Docker Compose

```yml
services:
  derper:
    image: zhz1021/derper
    container_name: derper
    environment:
      - TZ=Asia/Shanghai
      - DERP_CERT_MODE=manual
      - DERP_ADDR=:10088
      - DERP_HTTP_PORT=-1
      - DERP_STUN_PORT=10089
      - DERP_DOMAIN=your.domain.com
      - DERP_VERIFY_CLIENTS=true
    volumes:
      - /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock
      - ./certs:/app/certs
    ports:
      - 10088:10088
      - 10089:10089/udp
    restart: always
```

## 变量说明

| 变量                     |  是否必选 | 默认值                         | 备注                                   |
|------------------------|-------|-----------------------------|--------------------------------------|
| TZ                     | 否     | Asia/Shanghai               | 容器的时区                                |
| DERP_HOST              | 是     | your.hostname.com           | Derper 的域名            |
| DERP_CERT_DIR          | 否     | /app/certs                  | Derper 的域名证书存放路径                      |
| DERP_CERT_MODE         | 否     | letsencrypt/manual          |  可选项为 `letsencrypt`、`manual` |
| DERP_ADDR              | 否     | :443                        | Derper 的 HTTPS 监听端口                     |
| DERP_STUN              | 否     | true                        | 是否开启 STUN 穿透服务                         |
| DERP_STUN_PORT         | 否     | 3478                        | STUN 穿透的端口，该端口为 UDP 协议                  |
| DERP_HTTP_PORT         | 否     | 80                          | Derper 的 HTTP 监听端口，设置为 `-1` 可关闭             |
| DERP_VERIFY_CLIENTS    | 否     | false                       | 是否开启验证服务，避免被他人白嫖                     |
| DERP_VERIFY_CLIENT_URL | 否     | ""                          | 若值不为空，则会有允许客户端连接的外部验证链接，默认为空         |

- 若 `DERP_VERIFY_CLIENTS` 的值为 `true` ，可以添加路径映射 `/var/run/tailscale/tailscaled.sock` 到 Docker 容器内为 Derper 服务提供验证。

- Tailscale Derper 目前已官方支持纯 IP 部署（[详见此条Commit](https://github.com/tailscale/tailscale/commit/7fac0175c08565076f92b9ae4d2742dc8abda9af)），使用时需把 `DERP_HOST` 的值设置为你的服务器 IP 地址，把 `DERP_CERT_MODE` 设置为 `manual` ，启动时会自动生成自签名证书。

## Credits

[Tailscale](https://github.com/tailscale/tailscale)

[fredliang44/derper-docker](https://github.com/fredliang44/derper-docker)

[Tailscale 基础教程：部署私有 DERP 中继服务器](https://icloudnative.io/posts/custom-derp-servers)

[Tailscale DERP Docker版教程（国内 无需域名 IP+Port）](https://linux.do/t/topic/177517)