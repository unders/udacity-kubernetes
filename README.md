# Udacity Kubernetes ud615
This course is designed to teach you about managing application 
containers, using Kubernetes.


#### In this course you will learn to:
* Containerize an application by creating Docker config files and build 
  processes to produce all the necessary Docker images. 
* Configure and launch an auto-scaling, self-healing Kubernetes cluster.
* Use Kubernetes to manage deploying, scaling, and updating your 
  applications.
* Employ best practices for using containers in general, and specifically 
  Kubernetes, when architecting and developing new microservices.

#### Course
* [Scalable Microservices with Kubernetes by Google](https://www.udacity.com/course/scalable-microservices-with-kubernetes--ud615)
* [Course forum](https://discussions.udacity.com/c/standalone-courses/microservices-kubernetes)
* [My GitHub Repo](https://github.com/unders/ud615)



#### gcloud commands:

    $ gcloud init
    $ gcloud compute zones list
    $ gcloud config set compute/zone europe-west1-d
    $ gcloud config list
    $ gcloud info
    $ gcloud version
    $ gcloud config list

## Course start

### 1. monolith

    $ mkdir bin
    $ go build -o ./bin/monlith ./monolith/
    $ sudo ./bin/monlith -http=127.0.0.1:10080
    $ curl http://127.0.0.1:10080
    $ curl http://127.0.0.1:10080/secure         # -> authorization failed
    $ curl http://127.0.0.1:10080/login -u user  # write: password
    $ curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJleHAiOjE0OTAyNjI3OTgsImlhdCI6MTQ5MDAwMzU5OCwiaXNzIjoiYXV0aC5zZXJ2aWNlIiwic3ViIjoidXNlciJ9.mieXvNe3a0L5g7UKdC2HtrnWAeH2wAgcdk2ujpaDRtE" http://127.0.0.1:10080/secure

### 2. Microservices

    $ go build -o ./bin/hello ./hello/
    $ ./bin/hello -http=":10080" -health=":10081"

    $ go build -o ./bin/auth ./auth
    $ ./bin/auth -http=":10090" -health=":10091"
    $ curl http://localhost:10090/login -u user  # write password
    $ curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVzZXJAZXhhbXBsZS5jb20iLCJleHAiOjE0OTAyNjM5OTcsImlhdCI6MTQ5MDAwNDc5NywiaXNzIjoiYXV0aC5zZXJ2aWNlIiwic3ViIjoidXNlciJ9.7qpjI8ZBS92VTTBaI6I-oWn2-x7b4mOM2dB9r1EQsfY" http://localhost:10080/secure

### 3. Installing Apps With Native OS Tools

 * [video](https://classroom.udacity.com/courses/ud615/lessons/7826816435/concepts/81980819460923)

```
$ gcloud compute instances create ubuntu \
   --image-project ubuntu-os-cloud \
   --image ubuntu-1604-xenial-v20160420c
$ gcloud compute instances list
$ gcloud compute ssh ubuntu
$ sudo apt-get update
$ sudo apt-get install nginx
$ sudo systemctl start nginx
$ sudo systemctl status nginx
$ curl http://127.0.0.1
$ sudo ps aux | grep nginx
$ cat /etc/init/nginx.conf
$ sudo systemctl stop nginx

```
 ### 4. Docker
 
   * [Video 1](https://classroom.udacity.com/courses/ud615/lessons/7826816435/concepts/81980819530923)
   * [Video 2](https://classroom.udacity.com/courses/ud615/lessons/7826816435/concepts/81980819550923)

```
$ sudo apt-get install docker.io
$ sudo docker images
$ sudo docker pull nginx:1.10.0
$ sudo docker images
$ sudo dpkg -l | grep nginx
$ sudo docker run -d nginx:1.10.0
$ sudo docker ps
``` 


### 5. Dockerfile
 * [Video](https://classroom.udacity.com/courses/ud615/lessons/7826816435/concepts/81980819570923)

 **Note:**
    You have to explicitly make the binary static. This is really important in
    the Docker community right now because alpine has a different implementation
    of libc. So your go binary wouldn't have had the lib it needed if
    it wasn't static. You created a static binary so that your application
    could be self-contained.

    $  cat monolith/Dockerfile
    $ cd monolith
    $ cat Dockerfile
    $ GOOS=linux GOARCH=amd64 go build --tags netgo --ldflags '-extldflags "-lm -lstdc++ -static"'
    $ sudo docker build -t monolith:1.0.0 .
    $ sudo docker images monolith:1.0.0
    $ sudo docker run -p 8000:80 -p 8001:81 -d monolith:1.0.0
    $ curl localhost:8000  # {"message": "hello"}

    $ cd auth
    $ GOOS=linux GOARCH=amd64 go build --tags netgo --ldflags '-extldflags "-lm -lstdc++ -static"'
    $ sudo docker build -t auth:1.0.0 .
    $ sudo docker run -p 9000:80 -p 9001:81 -d auth:1.0.0
    $ curl localhost:9000/version

    $ cd hello
    $ GOOS=linux GOARCH=amd64 go build --tags netgo --ldflags '-extldflags "-lm -lstdc++ -static"'
    $ sudo docker build -t hello:1.0.0 .
    $ sudo docker run -p 10000:80 -p 10001:81 -d hello:1.0.0
    $ curl localhost:10000/version


### 6. Kubernetes

  * [kubectl Cheat Sheet](https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/)

```
$ gcloud container clusters create k0

$ kubectl run nginx --image=nginx:1.10.0
$ kubectl get pods
$ kubectl expose deployment nginx --port 80 --type LoadBalancer
$ kubectl get services
$ cat pods/monolith.yaml
$ kubectl create -f pods/monolith.yaml
$ kubectl get pods
$ kubectl describe pods monolith
```


### 7. Pods
   * [Video](https://classroom.udacity.com/courses/ud615/lessons/7824962412/concepts/81991020690923)

    $ kubectl port-forward monolith 10080:80
    $ curl http://127.0.0.1:10080
    $ curl http://127.0.0.1:10080/secure
    $ curl -u user http://127.0.0.1:10080/login
    $ curl -H "Authorization: Bearer <token>" http://127.0.0.1:10080/secure
    $ kubectl logs -f monolith
    $ curl http://127.0.0.1:10080
    $ kubectl exec monolith --stdin --tty -c monolith /bin/sh
    $ ping -c 3 google.com

### 8. Monitoring and Health Checks

  * [Configuring Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/)

#### 9. Secrets

   * [Video](https://classroom.udacity.com/courses/ud615/lessons/7824962412/concepts/81991020760923)
   * [Video 2](https://classroom.udacity.com/courses/ud615/lessons/7824962412/concepts/81991020770923)
   * [Using ConfigMap](https://kubernetes.io/docs/user-guide/configmap/)
   * [Secrets](https://kubernetes.io/docs/user-guide/secrets/)
   * [Secrets Desing Proposal](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/secrets.md)

    $ ls tls
    $ kubectl create secret generic tls-certs --from-file=tls/
    $ kubectl describe secrets tls-certs
    $ kubectl create configmap nginx-proxy-conf --from-file=nginx/proxy.conf
    $ kubectl describe configmap nginx-proxy-conf

    $ kubectl create -f pods/secure-monolith.yaml
    $ kubectl get pods secure-monolith
    $ kubectl port-forward secure-monolith 10443:443
    $ curl --cacert tls/ca.pem https://127.0.0.1:10443
    $ kubectl logs -c nginx secure-monolith

#### 10 Services

 * [Services User Guide](https://kubernetes.io/docs/user-guide/services/)
 

The wrong way:

```
$ cat services/monolith.yaml
$ kubectl create -f services/monolith.yaml
$ gcloud compute firewall-rules create allow-monolith-nodeport --allow=tcp:31000
$ gcloud compute instances list
$ kubectl get services
$ kubectl get pods -l "app=monolith"
$ kubectl get pods -l "app=monolith,secure=enabled"
$ kubectl describe pods secure-monolith
$ kubectl label pods secure-monolith "secure=enabled"
$ kubectl get pods -l "app=monolith,secure=enabled"
$ curl -k https://35.187.112.96:31000
```

### 11 Deploying Microservices
         $ kubectl create -f deployments/auth.yaml
         $ kubectl get deployments
         $ kubectl describe deployments auth
         $ kubectl create -f services/auth.yaml
         $ kubectl create -f deployments/hello.yaml
         $ kubectl create -f services/hello.yaml
         $ kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
         $ kubectl create -f deployments/hello.yaml
         $ kubectl create -f services/frontend.yaml
         $ kubectl get service frontend
         $ curl -k https://104.199.67.75/

### 12 Scaling Deployments

     $ kubectl get replicasets
     $ kubectl get pods -l "app=hello,track=stable"
     ## Update number of replicas...
     $ kubectl apply -f deployments/hello.yaml
     $ kubectl get pods -l "app=hello,track=stable"
     $ kubectl get replicasets
     $ kubectl get pods
     $ kubectl describe deployments hello

### 13 Rolling Updates

    ## update deployments/auth.yaml to a later version
    $ kubectl apply -f deployments/auth.yaml
    $ kubectl describe deployments auth
    $ kubectl describe pods auth-3099428890-r045n

## Google Cloud Platform

### SDK - Console
* [SDK](https://cloud.google.com/sdk/)

### Go Client - Programmable
* [Client Libraries Explained](https://cloud.google.com/apis/docs/client-libraries-explained)
* [Go on GCP](https://cloud.google.com/go/home)
* [Go APIs on GCP](https://cloud.google.com/go/apis)
* [Auto-generated Google APIs for Go](https://github.com/google/google-api-go-client)

### Container builder
* [Quick start](https://cloud.google.com/container-builder/docs/quickstart-gcloud)
* [](https://cloud.google.com/sdk/gcloud/reference/container/builds/)

### Container Registry
 * [Container Registry Documentation](https://cloud.google.com/container-registry/docs/)

### Source Repos
* [Connecting a GitHub Repository](https://cloud.google.com/source-repositories/docs/connecting-hosted-repositories)
* [Adding a repo as a remote](https://cloud.google.com/source-repositories/docs/adding-repositories-as-remotes)
* [Docs](https://cloud.google.com/source-repositories/docs/)

## Alpine
* [A minimal Docker image based on Alpine Linux](https://hub.docker.com/_/alpine/)

## Docker
* [Docker Mac Networking](https://docs.docker.com/docker-for-mac/networking/)

## JWT
* [JWT](https://jwt.io/)

## 12 Factor apps
* [12factor](https://12factor.net/)
