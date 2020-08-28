output "kubernetes-cert-manager-dns-iam-user" {
  value = module.r53.kubernetes-cert-manager-dns-iam-user
}

output "kubernetes-cert-manager-dns-iam-key" {
  value = module.r53.kubernetes-cert-manager-dns-iam-key
}

output "kubernetes-external-dns-iam-user" {
  value = module.r53.kubernetes-external-dns-iam-user
}

output "kubernetes-external-dns-iam-key" {
  value = module.r53.kubernetes-external-dns-iam-key
}

output "podcast-github-s3-iam-user" {
  value = module.podcast.podcast-github-s3-iam-user
}

output "podcast-github-s3-iam-key" {
  value = module.podcast.podcast-github-s3-iam-key
}

output "podcast-episodes-bucket-name" {
  value = module.podcast.podcast-episodes-bucket-name
}

output "podcast-episodes-bucket-region" {
  value = module.podcast.podcast-episodes-bucket-region
}
