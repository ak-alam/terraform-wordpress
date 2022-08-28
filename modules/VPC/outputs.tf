output "vpcId_out" {
  value = aws_vpc.vpc.id
}
output "publicSubtnet_out" {
  value = aws_subnet.publicSubnet.*.id
}
output "privateSubnet_out" {
  value = aws_subnet.privateSubnet.*.id
}