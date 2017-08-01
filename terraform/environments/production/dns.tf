resource "aws_route53_zone" "hashbang" {
    name = "hashbang.sh"
}

// A
resource "aws_route53_record" "mail-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "mail.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.236.46.93"]
}

resource "aws_route53_record" "sfo1-irc-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "sfo1.irc.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.236.128.136"]
}

resource "aws_route53_record" "lon1-irc-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "lon1.irc.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["178.62.33.133"]
}

// GEO
resource "aws_route53_record" "irc-ipv4-default" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "irc.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.236.128.136"]

    set_identifier = "default"
    geolocation_routing_policy {
        country = "*"
    }
}

resource "aws_route53_record" "irc-ipv4-us" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "irc.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.236.128.136"]

    set_identifier = "us"
    geolocation_routing_policy {
    	continent = "NA"
    }
    health_check_id = "${aws_route53_health_check.irc-us.id}"
}

resource "aws_route53_record" "irc-ipv4-eu" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "irc.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["178.62.33.133"]

    set_identifier = "eu"
    geolocation_routing_policy {
    	continent = "EU"
    }
    health_check_id = "${aws_route53_health_check.irc-eu.id}"
}

// HEALTHCHECKS
resource "aws_route53_health_check" "irc-us" {
  ip_address        = "104.236.128.136"
  port              = 6697
  type              = "TCP"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "tf-irc-us"
  }
}

resource "aws_route53_health_check" "irc-eu" {
  ip_address        = "178.62.33.133"
  port              = 6697
  type              = "TCP"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "tf-irc-eu"
  }
}

// A + AAAA PAIRS
resource "aws_route53_record" "ldap-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "ldap.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:800:a1::41c:6001"]
}
resource "aws_route53_record" "ldap-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "ldap.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["159.203.127.193"]
}

resource "aws_route53_record" "sf1-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "sf1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2001:470:1f05:82e::"]
}
resource "aws_route53_record" "sf1-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "sf1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["45.58.38.222"]
}

resource "aws_route53_record" "da1-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "da1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2001:470:1f0f:645::"]
}
resource "aws_route53_record" "da1-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "da1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.245.35.240"]
}

resource "aws_route53_record" "ny1-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "ny1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2001:470:1f07:11f4::"]
}
resource "aws_route53_record" "ny1-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "ny1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["45.58.35.111"]
}

resource "aws_route53_record" "to1-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "to1.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2001:470:1d:5fe::"]
}
resource "aws_route53_record" "to1-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "to1.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.245.37.138"]
}

resource "aws_route53_record" "services-irc-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "services.irc.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:800:10::120a:7001"]
}
resource "aws_route53_record" "services-irc-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "services.irc.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["45.55.71.38"]
}

resource "aws_route53_record" "im-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "im.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:1:20::db8:5001"]
}
resource "aws_route53_record" "im-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "im.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["107.170.254.61"]
}

resource "aws_route53_record" "www-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "www.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:800:10::1909:a001"]
}
resource "aws_route53_record" "www-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "www.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.131.13.197"]
}

resource "aws_route53_record" "hashbang-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:800:10::1909:a001"]
}
resource "aws_route53_record" "hashbang-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.131.13.197"]
}

resource "aws_route53_record" "voip-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "voip.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:2:d0::17d:6001"]
}
resource "aws_route53_record" "voip-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "voip.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["138.68.57.139"]
}

resource "aws_route53_record" "nyc3-apps-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "nyc3.apps.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:800:10::17cb:1001"]
}
resource "aws_route53_record" "nyc3-apps-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "nyc3.apps.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["104.236.85.7"]
}

// TXT
resource "aws_route53_record" "dmarc-txt" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "_dmarc.${aws_route53_zone.hashbang.name}"
    type = "TXT"
    ttl  = "1800"
    records = ["v=DMARC1; p=none; pct=100; rua=mailto:re+niiphewtj3k@dmarc.postmarkapp.com; sp=none; aspf=s;"]
}

resource "aws_route53_record" "spf-txt" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "${aws_route53_zone.hashbang.name}"
    type = "TXT"
    ttl  = "1800"
    records = ["v=spf1 +mx -all"]
}


// ALIAS
resource "aws_route53_record" "va1-alias" {
  zone_id = "${aws_route53_zone.hashbang.zone_id}"
  name = "va1.${aws_route53_zone.hashbang.name}"
  type = "CNAME"
  ttl = "1800"
  records = ["ny1.${aws_route53_zone.hashbang.name}"]
}

resource "aws_route53_record" "git-infra-alias" {
  zone_id = "${aws_route53_zone.hashbang.zone_id}"
  name = "git-infra.${aws_route53_zone.hashbang.name}"
  type = "CNAME"
  ttl = "1800"
  records = ["nyc3.apps.${aws_route53_zone.hashbang.name}"]
}

// MX
resource "aws_route53_record" "mx" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "${aws_route53_zone.hashbang.name}"
    type = "MX"
    ttl  = "1800"
    records = [
        "10 mail.${aws_route53_zone.hashbang.name}"
    ]
}

// temporary?
resource "aws_route53_record" "brokenchat-ipv6" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "brokenchat.${aws_route53_zone.hashbang.name}"
    type = "AAAA"
    ttl  = "1800"
    records = ["2604:a880:800:10::189c:f001"]
}
resource "aws_route53_record" "brokenchat-ipv4" {
    zone_id = "${aws_route53_zone.hashbang.zone_id}"
    name = "brokenchat.${aws_route53_zone.hashbang.name}"
    type = "A"
    ttl  = "1800"
    records = ["45.55.162.19"]
}
