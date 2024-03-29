resource "aws_s3_bucket" "s3-upload-test-amit" {
  bucket = var.s3bucket

  tags = {
    Name        = "s3-upload-test-amit"
    Environment = "test"
  }
}
resource "aws_s3_bucket_ownership_controls" "s3-upload-test-amit" {
  bucket = aws_s3_bucket.s3-upload-test-amit.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-upload-test-amit" {
  bucket = aws_s3_bucket.s3-upload-test-amit.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}





data "aws_iam_policy_document" "s3-upload-test-amit-upload-bucket-policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.accountid}:role/s3-rds-cloudwatch-role"]
    }

    actions = [
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
    ]

    resources = [
      "arn:aws:s3:::${var.s3bucket}/*",
      "arn:aws:s3:::${var.s3bucket}",
    ]
  }


  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.accountid}:role/s3-rds-cloudwatch-role"]
    }


    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.s3bucket}/*",
      "arn:aws:s3:::${var.s3bucket}",
    ]


    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "*"
      ]
    }

  }




}



resource "aws_s3_bucket_policy" "s3-upload-test-amit-upload-bucket-policy" {
  bucket = aws_s3_bucket.s3-upload-test-amit.id
  policy = data.aws_iam_policy_document.s3-upload-test-amit-upload-bucket-policy.json
}
