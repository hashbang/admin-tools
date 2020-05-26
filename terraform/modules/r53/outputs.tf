output "kubernetes-cert-manager-dns-iam-user" {
  value = aws_iam_access_key.kubernetes-cert-manager-dns.id
}

output "kubernetes-cert-manager-dns-iam-key" {
  value = aws_iam_access_key.kubernetes-cert-manager-dns.secret
}
