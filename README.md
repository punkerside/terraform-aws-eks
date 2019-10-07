# Amazon Elastic Container Service for Kubernetes - EKS

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

![IMAGE](docs/img/architecture.png)

Kubernetes es un software de código abierto que le permite implementar y administrar aplicaciones en contenedores a escala. Kubernetes administra clústeres de instancias de informática de Amazon EC2 y ejecuta contenedores en ellas con procesos destinados a implementación, mantenimiento y escalado.

## Prerequisite


* [Instalar Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
* [Instalar AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

**NOTA:** Configurar las credenciales en el servicio [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/configure/).

Como depedencia se necesita una infraestructura base debidamente etiquetada para poder detectar automaticamente los distintos componentes de red. Para esto podemos seguir la siguiente plantilla de VPC:

* [Amazon Virtual Private Cloud](https://github.com/punkerside/terraform-aws-template-vpc)

## Recursos desplegados

### Amazon AWS

* Elastic Container Service for Kubernetes (EKS)
* EC2 [Spot Instances](https://aws.amazon.com/es/ec2/spot/)
* EC2 Auto Scaling
* Elastic Load Balancing (ELB)
* Identity and Access Management (IAM)
* CloudWatch Container Insights
* Certificate Manager
* Simple Notification Service
* Route 53

### Kubernetes

* Web UI (Dashboard)
* Metrics Server
* Cluster Autoscaler (CA)
* NGINX Ingress Controller
* GuestBook (app demo)

## Inicio rápido

Para desplegar toda la infraestructura necesaria de una forma rapida podemos ejecutar:

```bash
make quickstart AWS_REGION=us-west-2 NODE_VER=1.13
```

* **GuestBook**

http://guestbook.punkerside.com

* **Web UI (Dashboard)**

```bash
# obtener token
sh scripts/eks-admin.sh
# iniciar dashboard
kubectl proxy
```

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| OWNER | Nombre del propietario | string | punkerside | no |
| PROJECT | Nombre del proyecto | string | eks | no |
| ENV | Nombre del entorno | string | demo | no |
| AWS_REGION | Region de AWS | string | `us-east-1` | no |
| AWS_DOMAIN | Dominio de DNS | string | `punkerside.com` | no |
| NODE_VER | Version de Kubernetes | string | `1.14` | no |
| NODE_DES | Numero de nodos | string | `2` | no |
| NODE_MIN | Numero minimo de nodos para el escalamiento| string | `1` | no |
| NODE_MAX | Numero minimo de nodos para el escalamiento| string | `10` | no |

## Eliminar

Para eliminar la infraestructura creada y archivos temporales:

```bash
make delete
```