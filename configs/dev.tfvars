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
  "80" = ["0.0.0.0/0"]
}