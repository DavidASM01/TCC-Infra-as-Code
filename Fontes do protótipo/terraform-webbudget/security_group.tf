resource "aws_security_group" "acesso-web" { # Provisionando Grupo de segurança 
  name        = "acesso-web"
  description = "acesso-web"
  vpc_id      = aws_vpc.VPC_WEBBUCKET.id

# Porta de conexão web segura https
  ingress { # Criando regra de entrada 
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidrsRemoteAcess
  }

# Porta de conexão web http
  ingress { # Criando regra de entrada 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidrsRemoteAcess
  }  

# Porta de gerência do servidor web windfly
  ingress { # Criando regra de entrada 
    from_port   = 9993
    to_port     = 9993
    protocol    = "tcp"
    cidr_blocks = var.cidrsRemoteAcess
  } 
  
  # liberação da comunicação de saida
    egress { # Criando regra de saida 
    protocol   = -1 # Todos os protocolos
    cidr_blocks = var.cidrsRemoteAcess
    from_port  = 0 #Libera todas as portas 
    to_port    = 0
  }
  tags = {
      Name = "acesso-web"
  }
}

# BLOQUEIO TOTAL DE ENTRADA

resource "aws_security_group" "blocked-all" {
  name        = "blocked-all"
  description = "blocked-all"
  vpc_id      = aws_vpc.VPC_WEBBUCKET.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = var.cidrsRemoteAcess
  }
 
  egress {
    protocol   = -1
    cidr_blocks = var.cidrsRemoteAcess
    from_port  = 0 
    to_port    = 0
  }

  tags = {
    Name = "blocked-all"
  }
}


# ACESSO LIBERADO ENTRE AS INSTANCIAS 

resource "aws_security_group" "internal-access" {
  name        = "internal-access"
  description = "internal-access"
  vpc_id      = aws_vpc.VPC_WEBBUCKET.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [aws_vpc.VPC_WEBBUCKET.cidr_block,var.cidrsControler]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [aws_vpc.VPC_WEBBUCKET.cidr_block,var.cidrsControler]
  }

  tags = {
    Name = "internal-access"
  }
}
