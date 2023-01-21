// Create Instance profile

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.app_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.instance_role.name

}

resource "aws_iam_role" "instance_role" {
  name = "${var.app_name}-${var.environment}-ec2-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

    tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-ec2-role"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.app_name}-${var.environment}-ec2-policy"
  description = "${aws_s3_bucket.bucket.id} s3 bucket permissions"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]

}
EOT
}

resource "aws_iam_role_policy_attachment" "app_instance_policy_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

// Attach SSM policy

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {

  policy_arn  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role        = aws_iam_role.instance_role.name
}

// Attach Cloudwatch Policy

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {

  policy_arn  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role        = aws_iam_role.instance_role.name
}