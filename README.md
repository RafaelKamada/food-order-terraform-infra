# Projeto de Infraestrutura Kubernetes com Terraform

## 📌 Visão Geral

Este repositório contém a configuração de infraestrutura para Kubernetes dos serviços com Terraform. O projeto segue as melhores práticas de CI/CD, garantindo automação e segurança no deploy dos recursos.

## 🏗️ Arquitetura

A infraestrutura é composta por:
- Cluster Kubernetes (EKS): Provisionado via Terraform para orquestração de contêineres.
- API Gateway + AWS Lambda: Implementação de autenticação de clientes via CPF.
- Deploy Automatizado: Utilizando GitHub Actions com proteção de branches.


## 🚀 Tecnologias Utilizadas

- Terraform: Para provisionamento da infraestrutura.
- Kubernetes: Para orquestração de contêineres.
- GitHub Actions: Para CI/CD automatizado.
- AWS Lambda (Elixir): Para autenticação via CPF.
- API Gateway: Para intermediar requisições entre clientes e backend.

## 📁 Estrutura do Repositório
```
food-order-terraform-db
├── .github/workflows/  # Configuração dos pipelines de CI/CD
│   ├── terraform.yml  # Workflow para provisionamento da infraestrutura AWS com Terraform
├── k8s/
│   ├── api-deployment.yaml  # Definição do deployment da API no Kubernetes
│   ├── api-pod.yaml  # Definição do pod para a API
│   ├── api-service.yaml  # Serviço para expor a API
├── api-gateway.tf  # Definições da api gateway
├── data.tf  # Definições de dados e recursos compartilhados
├── eks-access-entry.tf  # Configuração de regras de acesso ao EKS
├── eks-access-policy.tf  # Políticas de acesso e permissões para o EKS
├── eks-cluster.tf  # Configuração do cluster EKS na AWS
├── eks-node.tf  # Configuração do node do Cluster EKS na AWS
├── gateways.tf  # Configurações de internet gateway;
├── loud-balancer.tf  # Configurações do LoadBalancer;
├── outputs.tf  # Saídas do Terraform para referência
├── provider.tf  # Configuração do provider AWS no Terraform
├── routes.tf  # Configuração de routes AWS no Terraform
├── sg.tf  # Regras de segurança do Security Group
├── subnets.tf  # Configuração das subnets da VPC
├── vars.tf  # Definição de variáveis do Terraform
├── versions.tf  # Definição de versões para o Provider
└── README.md  # Documentação do projeto
```

## 🔧 Configuração e Deploy
### 📌 Pré-requisitos
- Terraform instalado
- AWS CLI configurado
- kubectl instalado

## 🚀 Passos para Deploy

1. Clone o repositório: 
```git clone https://github.com/RafaelKamada/food-order-terraform-infra.git```
```cd food-order-terraform-infra```

2. Inicialize o Terraform:
```terraform init```

3. Valide e aplique a infraestrutura:
```terraform plan```
```terraform apply```

4. Configure o contexto do Kubernetes:
```aws eks update-kubeconfig --name nome-do-cluster --region regiao```

5. Implante aplicações no cluster:
```kubectl apply -f k8s/```

## 🔑 Configuração do Secrets no GitHub

### 1️⃣ Acesse as configurações do repositório
1. Vá até o repositório no GitHub.
2. Clique em Settings.
3. No menu lateral, clique em Secrets and variables > Actions.
4. Clique em New repository secret.

#### 2️⃣ Adicione as Secrets necessárias
✅ Para autenticação na AWS
Essas credenciais são usadas pelo Terraform e pelo GitHub Actions para acessar a AWS.

    | Nome da secret           | Descrição                                                                |
    | :------------------------| :------------------------------------------------------------------------|
    | `AWS_ACCESS_KEY_ID`      | Chave de acesso da AWS                                                   |
    | `AWS_SECRET_ACCESS_KEY`  | Chave secreta da AWS                                                     |
    | `AWS_SESSION_TOKEN`      | (Opcional) Token de sessão, se estiver usando credenciais temporárias    |

✅ Outras Secrets
Caso sua aplicação use um banco de dados ou outra API, adicione as credenciais necessárias.

    | Nome da secret           | Descrição                  |
    | :------------------------| :--------------------------|
    | `DB_NAME`                | Nome do Banco de Dados     |
    | `DB_USERNAME`            | Usuário do banco de dados  |
    | `DB_PASSWORD`            | Senha do banco de dados    |

✅ Configuração das variáveis no vars.tf
Você precisará ajustar as variáveis de configuração no arquivo `vars.tf`, incluindo o ARN do principal e o ARN do RDS. Essas variáveis são essenciais para autenticar e acessar os recursos da AWS.

Exemplo de variáveis:
````
variable "principalArn" {
  description = "ARN da função IAM principal para acessar recursos"
  default     = "arn:aws:iam::198212171636:role/voclabs"
}

variable "labRole" {
  description = "ARN do LabRole utilizado para gerenciamento de recursos"
  default     = "arn:aws:iam::198212171636:role/LabRole"
}
````

Passos:
1. `principalArn`: Esse valor corresponde ao ARN da função IAM que o Terraform usará para acessar os recursos. Certifique-se de substituir o valor pelo ARN correto de sua conta AWS.

2. `labRole`: Esse valor é o ARN de uma função IAM usada para gerenciar os recursos de seu laboratório ou ambiente de testes. Certifique-se de substituir o valor pelo ARN correto da função que você deseja usar.

Com essas variáveis configuradas, o Terraform poderá utilizar os recursos da AWS de forma segura, garantindo que sua infraestrutura seja criada e configurada corretamente.

