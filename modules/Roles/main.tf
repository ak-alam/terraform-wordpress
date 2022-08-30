resource "aws_iam_role" "role" {
  name = "${var.prefix}-${var.role_name}-Role"

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

resource "aws_iam_role_policy" "policy" {
  name = "${var.prefix}-${var.role_name}-policy"  
  policy = var.policy_path
  role = aws_iam_role.role.id
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.prefix}-${var.role_name}-instanceProfile"
  role = aws_iam_role.role.name
}