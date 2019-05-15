# Setting up a kubernetes instance

Minikube is a good option if you want to setup a local kubernetes
cluster. Here are the instructions:

Run the following commands as root. You can get root shell by running:

```
sudo bash
```

After you get root shell, run the following commands:

```
apt update

apt install docker.io docker-compose

snap install kubectl --classic

curl -Lo minikube
https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
&& chmod +x minikube && mv minikube /usr/local/bin/
```

Start minikube using:

```
minikube start --vm-driver=none
```
