// used for cert-manager
output "kubernetes-cert-manager-dns-iam-user" {
  value = aws_iam_access_key.kubernetes-cert-manager-dns.id
}

output "kubernetes-cert-manager-dns-iam-key" {
  value = aws_iam_access_key.kubernetes-cert-manager-dns.secret
}

// used for external-dns
output "kubernetes-external-dns-iam-user" {
  value = aws_iam_access_key.kubernetes-external-dns.id
}

output "kubernetes-external-dns-iam-key" {
  value = aws_iam_access_key.kubernetes-external-dns.secret
}
