vpc_ = {
  vpc_cidr = "10.0.0.0/16"
  public_subnet = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet = ["10.0.3.0/24", "10.0.4.0/24"]
}


role_name="SSM"


lb_IngressTraffic= {
  "80" = ["0.0.0.0/0"]
}
db_IngressTraffic={
  "3306" = ["0.0.0.0/0"]
  "22" = ["0.0.0.0/0"]
}
jumphost_IngressTraffic={
  "22" = ["0.0.0.0/0"]
}
web_IngressTraffic={
  "22" = ["0.0.0.0/0"]
  "80" = ["0.0.0.0/0"]
}

# Instance
ami="ami-0568773882d492fc8"
key_name="akbar.pem"
instance_type="t2.micro"

#Load balancer
tg_settings = [
    {
    HC_interval            = 10
    path                   = ""
    HC_healthy_threshold   = 5
    HC_unhealthy_threshold = 5
    HC_timeout             = null
    protocol               = "TCP"
    deregistration_delay   = 60
    port                   = 3306
    lb_name                = "NLB"
  },
  {
    HC_interval            = 10
    path                   = "/"
    HC_healthy_threshold   = 5
    HC_unhealthy_threshold = 5
    HC_timeout             = 5
    protocol               = "HTTP"
    deregistration_delay   = 60
    port                   = 80
    lb_name                = "ALB"
  }
]
deregistration_delay="60"

template_name="ASGTemplate"

#ASG
max_size=2
min_size=1
desired_capacity=2
healthCheck_grace_period=20