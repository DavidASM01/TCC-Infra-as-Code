# Ansible / Docker - Webbudget



[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Projeto consiste em demostrar a automatização de uma aplicação completa web desde a criação de sua infraestrutura na nuvem, instalação e configuração do back-end até o front- end (Banco de dados, Servidor Web, e código da aplicação) em servidores distintos para cada serviço, utilizando as tecnologias Docker / Docker-compose / Ansible / Terraform .

# Melhorias!

  - Combinação das tecnologias docker/docker-compose com Ansible.
  - Melhoria do código com utilização de roles 
  - Inventario dinamico do Ansible com o recurso local-exec do terraform.
  - Criação do certificado digital diretamente pela AWS.

### Instalação


O código requer [Ansible](https://www.ansible.com/) e o [Terraform](https://www.terraform.io/) para funcionar.

Você pode iniciar a criação da infraestrutura acessando o diretorio terraform-webbudget e executando o seguinte comando:

```sh
$ terraform init
$ terraform plan
$ terraform apply
```

Você pode iniciar o deploy do Ansible acessando o diretorio ansible-webbudget e executando o seguinte comando:  

```sh
$ ansible-playbook -l all -i ./inventory/hosts.yml provisioning.yml
```
