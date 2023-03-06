# Run Epinio in K3D Cluster

Deploy an Epinio environment using K3D. 

## Prerequisites

To execute this environment you'll need:

- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [K3D](https://k3d.io/v5.4.7/#installation)
- [Helm](https://helm.sh/docs/intro/install/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Epinio CLI](https://docs.epinio.io/installation/install_epinio_cli)

## What technologies were used

These technologies were used to deploy all necessary infrastructure for Epinio:

- K3S to deploy a kubernetes cluster;
- Cert Manager to provides SSL Certificates for apps;
- NGINX Ingress to act as Kubernetes Ingress ;
- Epinio to interface kubernetes cluster to developer;

## Deploy K3D + Epinio + App

For deploy the this environment in your machine you must be in root directory folder and run the following command:

``` bash
make deploy-epinio
```

This command will deploy a K3S Cluster and deploy Cert Manager, NGINX Ingress and Epinio.

To get Epinio endpoints use:

```bash
kubectl get ingress -A
```

And the output will look like:

```bash
NAMESPACE   NAME                        CLASS   HOSTS                                               ADDRESS                PORTS     AGE
epinio      dex                         nginx   auth.<IP of Loadbalancer>.omg.howdoi.website        <IP of Loadbalancer>   80, 443   xxx
epinio      epinio                      nginx   epinio.<IP of Loadbalancer>.omg.howdoi.website      <IP of Loadbalancer>   80, 443   xxx
```

Username and password of epinio interface will be *admin* and *password* respectively.

# Undeploy

To undeploy the environment including K3D cluster, Epinio and Clipboard app use the following command:

```bash
make undeploy-epinio
```

# Makefile functions

You can call individually these functions:

```bash
make deploy-epinio           # Deploy all environment
make undeploy-epinio         # Undeploy all environment
make deploy-k3d              # Deploy K3d Cluster
make init-helm               # Add all necessary Helm repos
make deploy-k8s-infraservice # Deploy NGINX Ingress and Cert Manager on current k8s context
make deploy-cert-manager     # Deploy Cert Manager on current k8s context
make deploy-ingress-nginx    # Deploy NGINX Ingress on current k8s context
make deploy-epinio           # Deploy Epinio on current k8s context
make epinio-login            # Execute login on Epinio
```