// used for GitHub to access s3 bucket
output "podcast-github-s3-iam-user" {
  value = aws_iam_access_key.podcast-github-s3.id
}

output "podcast-github-s3-iam-key" {
  value = aws_iam_access_key.podcast-github-s3.secret
}

output "podcast-episodes-bucket-name" {
  value = aws_s3_bucket.podcast-episodes.bucket
}

output "podcast-episodes-bucket-region" {
  value = aws_s3_bucket.podcast-episodes.region
}
