locals {
  dns_record_check_ttl = 300
}

resource "cloudflare_dns_record" "soubilabs_blog" {
  for_each = toset(["blog", "www.blog"])

  zone_id = var.soubilabs_zone_id
  name    = each.key
  type    = "CNAME"
  content = "hashnode.network"
  ttl     = local.dns_record_check_ttl
  proxied = false
}

resource "cloudflare_dns_record" "soubilabs" {
  for_each = toset(["@", "www"])

  zone_id = var.soubilabs_zone_id
  name    = each.key
  type    = "CNAME"
  content = "soubinan.github.io"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "soubilabs_mtasts_custom_domain" {
  zone_id = var.soubilabs_zone_id
  name    = "_mta-sts"
  type    = "CNAME"
  content = "_mta-sts.mx.cloudflare.net"
  ttl     = local.dns_record_check_ttl
  proxied = false
}

resource "cloudflare_dns_record" "soubilabs_dmarc" {
  zone_id = var.soubilabs_zone_id
  name    = "_dmarc"
  type    = "TXT"
  content = "\"v=DMARC1;p=reject;pct=100;rua=mailto:be86d89b7ea440ccb7a24ba9c18d7fb4@dmarc-reports.cloudflare.net,mailto:a1b8e51de9@rua.easydmarc.us;ruf=mailto:a1b8e51de9@ruf.easydmarc.us;ri=86400;aspf=s;adkim=s;fo=1\""
  ttl     = local.dns_record_check_ttl
}

resource "cloudflare_dns_record" "soubilabs_mx" {
  for_each = {
    mx1 = {
      index    = 1
      priority = 5
    }
    mx2 = {
      index    = 2
      priority = 11
    }
    mx3 = {
      index    = 3
      priority = 48
    }
  }

  zone_id  = var.soubilabs_zone_id
  name     = "@"
  type     = "MX"
  content  = "route${each.value.index}.mx.cloudflare.net"
  ttl      = local.dns_record_check_ttl
  priority = each.value.priority
}

resource "cloudflare_dns_record" "soubilabs_spf" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  type    = "TXT"
  content = "\"v=spf1 include:_spf.mx.cloudflare.net include:smtp-brevo.com ~all\""
  ttl     = local.dns_record_check_ttl
}

resource "cloudflare_dns_record" "soubilabs_dkim" {
  for_each = {
    1 = {
      name    = "s1._domainkey"
      content = "\"v=DKIM1; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCvAW6v9kbrGXTGsgzIXvs0IHC5ZjZYpNjCmOB2LueZ3r/DsXC1LYz8w1f0rrO6Ln3fe/8zPYcV0M6NMAhJqkuvaSJrsFjcz7OJVWJKQhfY8G1bYRrD6Xau1cDQyLSnUxCWrFwH6tiZumdDv6I28NJymR17+xdwSgV3YB8LVm5AwIDAQAB\""
    }
    2 = {
      name    = "cf2024-1._domainkey"
      content = "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78km4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB\""
    }
  }
  zone_id = var.soubilabs_zone_id
  name    = each.value.name
  type    = "TXT"
  content = each.value.content
  ttl     = local.dns_record_check_ttl
}

resource "cloudflare_dns_record" "soubilabs_mtasts" {
  zone_id = var.soubilabs_zone_id
  name    = "_mta-sts"
  type    = "TXT"
  content = "\"v=STSv1; id=169691518796Z;\""
  ttl     = local.dns_record_check_ttl
}

resource "cloudflare_dns_record" "soubilabs_tlsrpt" {
  zone_id = var.soubilabs_zone_id
  name    = "_smtp._tls"
  type    = "TXT"
  content = "\"v=TLSRPTv1; rua=mailto:soubinan@gmail.com;\""
  ttl     = local.dns_record_check_ttl
}

########## Github Org verification
resource "cloudflare_dns_record" "soubilabs_gh_org" {
  zone_id = var.soubilabs_zone_id
  name    = "_gh-SoubiLabs-o"
  type    = "TXT"
  content = "\"4408c51e29\""
  ttl     = local.dns_record_check_ttl
}

########## Brevo email sender
resource "cloudflare_dns_record" "soubilabs_brevo_dkim" {
  count   = length([1, 2])
  zone_id = var.soubilabs_zone_id
  name    = "brevo${count.index}._domainkey"
  type    = "CNAME"
  content = "b${count.index}.soubilabs-xyz.dkim.brevo.com"
  ttl     = local.dns_record_check_ttl
  proxied = false
}

resource "cloudflare_dns_record" "soubilabs_brevo_code" {
  zone_id = var.soubilabs_zone_id
  name    = "@"
  type    = "TXT"
  content = "\"brevo-code:8e59d23b7258bb35f1dead22434df2c6\""
  ttl     = local.dns_record_check_ttl
}
