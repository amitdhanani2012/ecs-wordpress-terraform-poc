resource "aws_iam_policy" "s3-rds-cloudwatch-policy" {
  name        = "s3-rds-cloudwatch-policy"
  path        = "/"
  description = "s3-rds-cloudwatch-policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
       "Effect" : "Allow",
       "Action" : [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl",
        ],
          "Resource" : ["${aws_s3_bucket.s3-upload-test-amit.arn}/*", "${aws_s3_bucket.s3-upload-test-amit.arn}/"]
        },

    
       {
           "Effect" : "Allow",
           "Action" : [
             "s3:ListBucket",
              ],
           "Resource" : ["${aws_s3_bucket.s3-upload-test-amit.arn}/*", "${aws_s3_bucket.s3-upload-test-amit.arn}/"]

            "Condition": {
              "StringLike": {
                  "s3:prefix": "*"
             }
        }
              
        },





        {
          "Sid" : "SecretsManagerDbCredentialsAccess",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue",
            "secretsmanager:PutResourcePolicy",
            "secretsmanager:PutSecretValue",
            "secretsmanager:DeleteSecret",
            "secretsmanager:DescribeSecret",
            "secretsmanager:TagResource"
          ],
          "Resource" : ["arn:aws:secretsmanager:*:*:secret:rds-db-credentials/*", "arn:aws:secretsmanager:*:*:secret:rds-db-credentials/"]
        },
        {
          "Sid" : "RDSDataServiceAccess",
          "Effect" : "Allow",
          "Action" : [
            "dbqms:CreateFavoriteQuery",
            "dbqms:DescribeFavoriteQueries",
            "dbqms:UpdateFavoriteQuery",
            "dbqms:DeleteFavoriteQueries",
            "dbqms:GetQueryString",
            "dbqms:CreateQueryHistory",
            "dbqms:DescribeQueryHistory",
            "dbqms:UpdateQueryHistory",
            "dbqms:DeleteQueryHistory",
            "rds-data:ExecuteSql",
            "rds-data:ExecuteStatement",
            "rds-data:BatchExecuteStatement",
            "rds-data:BeginTransaction",
            "rds-data:CommitTransaction",
            "rds-data:RollbackTransaction",
            "secretsmanager:CreateSecret",
            "secretsmanager:ListSecrets",
            "secretsmanager:GetRandomPassword",
            "tag:GetResources"
          ],
          "Resource" : ["${aws_db_instance.wordpress.arn}/*", "${aws_db_instance.wordpress.arn}/"]
        },

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


resource "aws_iam_role" "s3-rds-cloudwatch-role" {
  name = "s3-rds-cloudwatch-role"

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
    "s3-rds-cloudwatch-role" : "s3-rds-cloudwatch-role"
  }
}

resource "aws_iam_policy_attachment" "s3-rds-cloudwatch-role" {
  name       = "s3-rds-cloudwatch-role"
  roles      = [aws_iam_role.s3-rds-cloudwatch-role.name]
  policy_arn = aws_iam_policy.s3-rds-cloudwatch-policy.arn
}


