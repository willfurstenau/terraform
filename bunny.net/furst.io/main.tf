resource "bunnynet_dns_zone" "furst_io" {
  domain = "furst.io"
  log_enabled = true
}

resource "bunnynet_pullzone" "antarctica" {
  name = "8d293088-4"
  cache_enabled = true
  strip_cookies = false

  origin {
    forward_host_header = true
    type = "DnsAccelerate"
    url  = "https://104.131.177.207:443"
  }

  routing {
    tier = "Standard"
  }
}

resource "bunnynet_storage_zone" "furst_io" {
  name = "furst-io"
  region = "DE"
  zone_tier = "Standard"

  replication_regions = [
    "BR",
    "NY"
  ]
}

resource "bunnynet_pullzone" "furst_io" {
  name = "furst-io"
  cache_enabled = true

  origin {
    type = "StorageZone"
    storagezone = bunnynet_storage_zone.furst_io.id
  }

  routing {
    tier = "Standard"
  }
}

resource "bunnynet_dns_record" "furst_io" {
  zone = bunnynet_dns_zone.furst_io.id
  name = ""
  type = "CNAME"
  value = "${bunnynet_pullzone.furst_io.name}.b-cdn.net"
}

resource "bunnynet_pullzone_hostname" "bunnynet" {
  pullzone  = bunnynet_pullzone.furst_io.id
  name      = "furst.io"
  tls_enabled = true
  depends_on = [ bunnynet_dns_record.furst_io ]
}