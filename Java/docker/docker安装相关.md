# 安装docker的步骤

以WSL为例：

## 1.看是否为WSL2版本

```
uname -a
```

## 2.安装docker

- 更新软件包并安装依赖：

  ```
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  ```

- 添加 Docker 官方 GPG 密钥：

  ```
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  ```

- 添加 Docker APT 源：

  ```
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  ```

- 安装 Docker 引擎：

  ```
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  ```

## 3. **启动 Docker 服务**

WSL 不支持 systemd，需手动启动 Docker：

```
sudo service docker start
```