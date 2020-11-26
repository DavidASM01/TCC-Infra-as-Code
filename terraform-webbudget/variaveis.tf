#CONFIGURAÇÃO DE ACESSO SSH
## COLOQUE ABAIXO O IP DA MAQUINA CONTROLADORA DO ANSIBLE ##
variable "cidrsControler" {
    default = "179.158.9.184/32"
}
##---------------------------------------##-------------------------------------------##

##CONFIGURAÇÕES DA WEB

#Nome do dominio do site
variable "domainName" {
    default = "cariocatcc.com"
}

#Nome do  prefixo do do site
variable "prefixName" {
    default = "www"
}

#RANGE DE IP DA VPC
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}

#RANGE DE IP DA SUBNET

variable "publicsCIDRblock" {
    type = map(string)
    description = "publicsCIDRblock"
    default = {
        "1" = "10.0.1.0/24"
        "2" = "10.0.2.0/24"
    }
}

#RANGE DE IP DO CLIENTE DO SOFTWARE - CASO SEJA NECESSÁRIO RESTRINGIR O ACESSO A APLICAÇÃO A REDE DO CLIENTE 
variable "cidrsRemoteAcess" {
    type = list
    default = ["0.0.0.0/0"]    
}

##---------------------------------------##-------------------------------------------##

##VARIÁVEIS DAS MÁQUINAS VIRTUAIS##

variable "amis" {
    type = map(string)
    description = "AMIS"
    default = {
        sa-east-1 = "ami-083aa2af86ff2bd11"
    }
}
variable "region" {
     default = "sa-east-1" 
}

variable "keyname" {
     default = "webbudget" 
}

##---------------------------------------##-------------------------------------------##

##VARIÁVES DE REDE##

#VARIÁVEIS DA REDE VIRTUAL PRIVADA

variable "instanceTenancy" {
    default = "default"
}

variable "dnsSupport" {
    default = true
}

variable "dnsHostNames" {
    default = true
}

#VARIÁVEIS DA SUBNET

variable "mapPublicIP" {
    default = true
}

variable "availabilityZone" {
    type = map(string)
    description = "availabilityZone"
    default = {
        "a" = "sa-east-1a"
        "c" = "sa-east-1c"
    }
}

#VARIÁVEIS DA LISTA DE LISTA DE CONTROLE DE ACESSO.

variable "publicdestCIDRblock" {
    default = "0.0.0.0/0"
}