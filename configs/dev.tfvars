vpc_ = {
  vpc_cidr = "10.0.0.0/16"
  public_subnet = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet = ["10.0.4.0/24", "10.0.3.0/24"]
# private_subnet = []
}


role_name="SSM"


lb_IngressTraffic= {
  "80" = ["0.0.0.0/0"]
}
db_IngressTraffic={
  "3306" = ["0.0.0.0/0"]
}
web_IngressTraffic={
  "80" = []
}
source_SG=[]

# Instance
ami_="ami-0568773882d492fc8"
key_name="akbar.pem"
instance_type="t2.micro"

#Load balancer
protocol_nlb="TCP"
port_nlb="3306"
protocol_alb="HTTP"
port_alb="80"

