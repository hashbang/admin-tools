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
