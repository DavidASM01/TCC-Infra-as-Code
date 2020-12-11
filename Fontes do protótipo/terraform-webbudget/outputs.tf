### Recursos para exportação de informações para o Ansible
resource "local_file" "AnsibleInventory" { # Gera um arquivo de inventário do Ansible a partir de um template com todos os endereços publicos atuais dos servidores provisionados  
 content = templatefile("${path.module}/templates/inventory.tmpl",
 {
  db-machine-ip = aws_instance.db-machine.public_ip,
  web-machine-ip = aws_instance.web-machine.public_ip,
  web-machine2-ip = aws_instance.web-machine2.public_ip
 }
 )
 filename = "${path.module}/../ansible-webbudget/inventory/hosts.yml" # Endereço de saida do arquivo de configuração provisionado 
}

resource "local_file" "Dns_webserver" { # Gera um arquivo de variaveis do Ansible contendo informações necessarias para a integração entre as ferramentas 
 content = templatefile("${path.module}/templates/all.tmpl",
 {
  web-machine-dns = aws_route53_record.www.fqdn, # Endereço web final do aplicativo provisionado
  db-machine-ip = aws_instance.db-machine.private_ip, # Endereço ip privado da maquina de banco de dados, para configuração na aplicação
 }
 )
 filename = "${path.module}/../ansible-webbudget/group_vars/all.yml" # Endereço de saida do arquivo de configuração provisionado 
}