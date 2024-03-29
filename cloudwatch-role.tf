resource "aws_iam_policy" "cloudwatch-policy" {
  name        = "cloudwatch-policy"
  path        = "/"
  description = "cloudwatch-policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:*",
          ],
          "Resource" : ["${aws_cloudwatch_log_group.wordpress.arn}/*", "${aws_cloudwatch_log_group.wordpress.arn}/", "${aws_cloudwatch_log_group.wordpress.arn}:log-stream:streaming/*", "${aws_cloudwatch_log_group.wordpress.arn}:log-stream:streaming/"]
        }
      ]
    }


  )
}


resource "aws_iam_role" "cloudwatch-access-role-amit" {
  name = "cloudwatch-access-role-amit"

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "cloudwatch-access-role-amit" : "cloudwatch-access-role-amit"
  }
}

resource "aws_iam_policy_attachment" "cloudwatch-access-role-amit" {
  name       = "cloudwatch-access-role-amit"
  roles      = [aws_iam_role.cloudwatch-access-role-amit.name]
  policy_arn = aws_iam_policy.cloudwatch-policy.arn
}


