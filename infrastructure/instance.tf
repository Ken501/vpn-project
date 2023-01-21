// Retrieve latest Amazon Linux 2 AMI

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

// Create Launch Template

resource "aws_launch_template" "launch_template" {
  name                   = "${var.app_name}-${var.environment}-launch-template"
  description            = "Launch template for ${var.app_name}"
  update_default_version = true
  image_id               = data.aws_ami.amazon-2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  user_data              = base64encode("../scripts/init.sh")

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

      tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-ec2"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

// Create test EC2 Instance

resource "aws_instance" "ec2_instance" {
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = var.instance_type
  user_data                   = file("../scripts/init.sh")
  subnet_id                   = aws_subnet.public.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  monitoring                  = true
  source_dest_check           = false

    tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-ec2"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

# Create Cloudwatch group and log stream

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.app_name}-${var.environment}-grp"
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.app_name}-${var.environment}-stream"
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
}