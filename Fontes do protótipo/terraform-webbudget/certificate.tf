resource "aws_acm_certificate" "cariocatcc" { # Criando um certificado para o dominio 
  domain_name       = "*.cariocatcc.com"
  validation_method = "DNS"
}

data "aws_route53_zone" "selected" { # Selecionando o nome do endereço do dominio previamente criado
  name = var.domainName
}


resource "aws_route53_record" "validation" { # Primeiro processo de avaliação do certificado digital com o dominio selecionado
  for_each = {
    for dvo in aws_acm_certificate.cariocatcc.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}

resource "aws_acm_certificate_validation" "validation" { # Segundo processo de avaliação do certificado digital com o dominio selecionado
  certificate_arn         = aws_acm_certificate.cariocatcc.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_elb" "lb" { # Provisionando um load balancer 
  name = "web-elb"
  security_groups = [aws_security_group.acesso-web.id] # Associando o load balancer a um grupo de segurança 
  subnets =  [aws_subnet.Public_subnet.id, aws_subnet.Public_subnet2.id] # Associando o load balancer a duas subnets

  listener { # Configurando a porta 80 como porta de escuta e porta de saida do load balancer. 
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener { # Configurando a porta 443 como porta de escuta e porta de saida do load balancer
    instance_port      = 443 
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = aws_acm_certificate_validation.validation.certificate_arn # Associando o cerificado digital a porta 443 do load balancer
 }

  health_check { # Verificando se a porta 443 está respondendo nos servidores de destino 
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:443/"
    interval            = 30
  }

  instances                   = [aws_instance.web-machine.id, aws_instance.web-machine2.id] # Associando os 2 servidores de aplicação como destino do load balancer 
  cross_zone_load_balancing   = false
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "Webbudget elb"
  }
}

resource "aws_route53_record" "www" { # Associando o endereço do dominio ao load balancer.
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.prefixName
  type    = "A"

  alias {
    name                   = aws_elb.lb.dns_name
    zone_id                = aws_elb.lb.zone_id
    evaluate_target_health = true
  }
}