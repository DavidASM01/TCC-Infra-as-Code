resource "aws_vpc" "VPC_WEBBUCKET" {  # Provisionando a rede virtual privada (VPC)
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "VPC_WEBBUCKET"
}
} 

#Subnets

resource "aws_subnet" "Public_subnet" {   # Provisionando a primeira subnet
  vpc_id                  = aws_vpc.VPC_WEBBUCKET.id
  cidr_block              = var.publicsCIDRblock["1"]
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone["a"]
tags = {
   Name = "Public subnet"
}
}

resource "aws_subnet" "Public_subnet2" { # Provisionando a segunda subnet
  vpc_id                  = aws_vpc.VPC_WEBBUCKET.id
  cidr_block              = var.publicsCIDRblock["2"]
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone["c"]
tags = {
   Name = "Public subnet2"
}
}

resource "aws_network_acl" "Public_NACL" { # # Provisionando a lista de controle de acesso da VPC
  vpc_id = aws_vpc.VPC_WEBBUCKET.id
  subnet_ids = [ aws_subnet.Public_subnet.id, aws_subnet.Public_subnet2.id ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.publicdestCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.publicdestCIDRblock 
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.publicdestCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = var.publicdestCIDRblock 
    from_port  = 9993
    to_port    = 9993
  }
  # Porta efêmera
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = var.publicdestCIDRblock 
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.publicdestCIDRblock
    from_port  = 0 
    to_port    = 0
  }
  
tags = {
    Name = "Public NACL"
}
}

resource "aws_internet_gateway" "IGW" { #Provisionando o gateway para acesso a internet
 vpc_id = aws_vpc.VPC_WEBBUCKET.id
 tags = {
        Name = "Internet gateway"
}
} 

resource "aws_route_table" "Public_RT" { # Criando uma tabela de roteamento
 vpc_id = aws_vpc.VPC_WEBBUCKET.id
 tags = {
        Name = "Public Route table"
}
} 

resource "aws_route" "internet_access" { # Anexando a tabela de roteamento ao intenet gateway
  route_table_id         = aws_route_table.Public_RT.id
  destination_cidr_block = var.publicdestCIDRblock
  gateway_id             = aws_internet_gateway.IGW.id
}

resource "aws_route_table_association" "Public_association" { #Associando a tabela de roteamento a primeira subnet
  subnet_id      = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table_association" "Public_association2" { #Associando a tabela de roteamento a segunda subnet
  subnet_id      = aws_subnet.Public_subnet2.id
  route_table_id = aws_route_table.Public_RT.id
}