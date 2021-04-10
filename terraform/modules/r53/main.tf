resource "aws_route53_zone" "hashbang" {
    name = "hashbang.sh"
}

// A
resource "aws_route53_record" "mail-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "mail.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.236.46.93"]
}

resource "aws_route53_record" "de1-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "de1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "de1-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "de1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "de1-ipv6-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.de1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "de1-ipv4-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.de1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "ca1-de2-cname" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "ca1.${aws_route53_zone.hashbang.name}"
    type = "CNAME"
    ttl  = "1800"
    records = ["de2.hashbang.sh."]
}
resource "aws_route53_record" "de2-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "de2.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["157.90.196.61"]
}

resource "aws_route53_record" "de2-ipv4-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.de2.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["157.90.196.61"]
}

resource "aws_route53_record" "de2-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "de2.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:252:3e22::61"]
}

resource "aws_route53_record" "de2-ipv6-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.de2.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:252:3e22::61"]
}

resource "aws_route53_record" "sf1-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "sf1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "sf1-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "sf1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "sf1-ipv6-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.sf1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "sf1-ipv4-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.sf1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "da1-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "da1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "da1-ipv4" {
zone_id = aws_route53_zone.hashbang.zone_id
    name = "da1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "da1-ipv6-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.da1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "da1-ipv4-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.da1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "ny1-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "ny1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "ny1-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "ny1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "ny1-ipv6-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.ny1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "ny1-ipv4-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.ny1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "to1-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "to1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "to1-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "to1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "to1-ipv6-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.to1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2a01:4f8:141:1272::2"]
}
resource "aws_route53_record" "to1-ipv4-wildcard" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "*.to1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["46.4.114.111"]
}

resource "aws_route53_record" "im-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "im.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:1:20::db8:5001"]
}
resource "aws_route53_record" "im-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "im.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["107.170.254.61"]
}

resource "aws_route53_record" "nyc3-apps-ipv6" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "nyc3.apps.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:800:10::17cb:1001"]
}
resource "aws_route53_record" "nyc3-apps-ipv4" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "nyc3.apps.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.236.85.7"]
}

// TXT
resource "aws_route53_record" "dmarc-txt" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = "_dmarc.${aws_route53_zone.hashbang.name}"
    type = "TXT"
    ttl  = "1800"
    records = ["v=DMARC1; p=none; pct=100; rua=mailto:re+niiphewtj3k@dmarc.postmarkapp.com; sp=none; aspf=s;"]
}

resource "aws_route53_record" "hashbang-txt" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = aws_route53_zone.hashbang.name
    type = "TXT"
    ttl  = "1800"
    records = ["v=spf1 +mx -all",
               "github-verification=pLnrWA79MbdJHxeWY8uxDXUaqDKbkhbJqtefK85f"]
}


// ALIAS
resource "aws_route53_record" "va1-alias" {
  zone_id = aws_route53_zone.hashbang.zone_id
  name = "va1.${aws_route53_zone.hashbang.name}"
  type = "CNAME"
  ttl = "1800"
  records = ["ny1.${aws_route53_zone.hashbang.name}"]
}

// MX
resource "aws_route53_record" "mx" {
    zone_id = aws_route53_zone.hashbang.zone_id
    name = aws_route53_zone.hashbang.name
    type = "MX"
    ttl  = "1800"
    records = [
        "10 mail.${aws_route53_zone.hashbang.name}"
    ]
}

// DNS managed by cert-manager
data "aws_iam_policy_document" "kubernetes-cert-manager-dns" {
    statement {
        actions = ["route53:GetChange"]
        resources = ["arn:aws:route53:::change/*"]
    }
    statement {
        actions = ["route53:ChangeResourceRecordSets",
                   "route53:ListResourceRecordSets"]
        resources = ["arn:aws:route53:::hostedzone/*"]
    }
    statement {
        actions = ["route53:ListHostedZonesByName"]
        resources = ["*"]
    }
}

resource "aws_iam_policy" "kubernetes-cert-manager-dns" {
    name = "kubernetes-cert-manager-dns"
    policy = data.aws_iam_policy_document.kubernetes-cert-manager-dns.json
}

resource "aws_iam_user" "kubernetes-cert-manager-dns" {
    name = "kubernetes-cert-manager-dns"
}

resource "aws_iam_user_policy_attachment" "kubernetes-cert-manager-dns" {
    user = aws_iam_user.kubernetes-cert-manager-dns.name
    policy_arn = aws_iam_policy.kubernetes-cert-manager-dns.arn
}

resource "aws_iam_access_key" "kubernetes-cert-manager-dns" {
  user = aws_iam_user.kubernetes-cert-manager-dns.name
}

// DNS managed by external-dns (https://github.com/kubernetes-sigs/external-dns/blob/v0.7.1/docs/tutorials/aws.md)
data "aws_iam_policy_document" "kubernetes-external-dns" {
    statement {
        actions = ["route53:ChangeResourceRecordSets",
                   "route53:ListResourceRecordSets"]
        resources = ["arn:aws:route53:::hostedzone/*"]
    }
    statement {
        actions = ["route53:ListHostedZones"]
        resources = ["*"]
    }
}

resource "aws_iam_policy" "kubernetes-external-dns" {
    name = "kubernetes-external-dns"
    policy = data.aws_iam_policy_document.kubernetes-external-dns.json
}

resource "aws_iam_user" "kubernetes-external-dns" {
    name = "kubernetes-external-dns"
}

resource "aws_iam_user_policy_attachment" "kubernetes-external-dns" {
    user = aws_iam_user.kubernetes-external-dns.name
    policy_arn = aws_iam_policy.kubernetes-external-dns.arn
}

resource "aws_iam_access_key" "kubernetes-external-dns" {
    user = aws_iam_user.kubernetes-external-dns.name
}
