resource "aws_iam_role" "IAMRole" {
  name = "${var.name}-${var.roleName}-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "IAMPolicy" {
  name = "${var.name}-${var.roleName}-policy"  
  policy = var.policyPath
  role = aws_iam_role.IAMRole.id
}

resource "aws_iam_instance_profile" "instanceProfile" {
  name = "${var.name}-${var.roleName}-instanceProfile"
  role = aws_iam_role.IAMRole.name
}