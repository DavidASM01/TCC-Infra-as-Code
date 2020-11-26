provider "aws" {        # Primeira parte do codigo onde é selecionado o provedor de serviços na nuvem a verão e a região. 
  version = "~> 3.0"
  region  = var.region
}


## INSTANCES ##  
resource "aws_instance" "db-machine" {  # Provisionando a maquina virtual db-machine
  subnet_id =  aws_subnet.Public_subnet.id # Informa a sub rede qua a maquina deve receber
  ami = var.amis["sa-east-1"] #Recebe o id da imagem do sistema operacional que a maquina deve receber 
  instance_type = "t2.micro" # Informa o tipo de servidor a ser provisionado 
  key_name = var.keyname # Informa a chave publica a ser instalada na maquina. 
  tags = { # Informa o nome da maquina para gerencia futura
    Name = "db-machine"
    }
  vpc_security_group_ids = [aws_security_group.blocked-all.id, aws_security_group.internal-access.id] # Informa os grupos de segurança que a maquina deve pertencer
}

resource "aws_instance" "web-machine" { # Provisionando a maquina virtual web-machine
  subnet_id = aws_subnet.Public_subnet.id
  ami = var.amis["sa-east-1"]
  instance_type = "t2.micro"
  key_name = var.keyname
  tags = {
    Name = "web-machine"
    }
  vpc_security_group_ids = [aws_security_group.acesso-web.id, aws_security_group.internal-access.id]
}

resource "aws_instance" "web-machine2" { # Provisionando a maquina virtual web-machine2
  subnet_id = aws_subnet.Public_subnet2.id
  ami = var.amis["sa-east-1"]
  instance_type = "t2.micro"
  key_name = var.keyname
  tags = {
    Name = "web-machine2"
    }
  vpc_security_group_ids = [aws_security_group.acesso-web.id, aws_security_group.internal-access.id]
}