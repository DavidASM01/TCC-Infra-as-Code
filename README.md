# Ansible / Docker - Webbudget



[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Projeto consiste em demostrar a automatização de uma aplicação completa web desde o back-end até o front- end (Banco de dados, Servidor Web, e código da aplicação) em servidores distintos para cada serviço, utilizando as tecnologias Docker / Docker-compose / Ansible .

# Melhorias!

  - Combinação das tecnologias docker/docker-compose com Ansible.
  - Melhoria do código com utilização de roles 

### Instalação

O código requer [Ansible](https://www.ansible.com/) para funcionar.

Atualize o host com endereços e chave privada dos servidores.

```sh
$ nano ./inventory/hosts.yml
```

Você pode iniciar o deploy com o seguinte comando  

```sh
$ ansible-playbook -l all -i ./inventory/hosts.yml provisioning.yml
```
