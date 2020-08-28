// Create bucket

resource "aws_s3_bucket" "podcast-episodes" {
  bucket_prefix = "podcast-episodes-"
  acl = "public-read"
}

// Create IAM access for bucket

data "aws_iam_policy_document" "podcast-github-s3" {
  statement {
    actions = ["s3:ListObject"]
    resources = [aws_s3_bucket.podcast-episodes.arn]
  }

  statement {
    actions = ["s3:PutObject", "s3:GetObject",
               "s3:PutObjectAcl", "s3:GetObjectAcl"]
    resources = ["${aws_s3_bucket.podcast-episodes.arn}/*"]
  }
}

resource "aws_iam_policy" "podcast-github-s3" {
  name = "podcast-github-s3"
  policy = data.aws_iam_policy_document.podcast-github-s3.json
}

resource "aws_iam_user" "podcast-github-s3" {
  name = "podcast-github-s3"
}

resource "aws_iam_user_policy_attachment" "podcast-github-s3" {
  user = aws_iam_user.podcast-github-s3.name
  policy_arn = aws_iam_policy.podcast-github-s3.arn
}

resource "aws_iam_access_key" "podcast-github-s3" {
  user = aws_iam_user.podcast-github-s3.name
}
