terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
    bigip = {
      source = "F5Networks/bigip"
      version = "1.6.0"
    }
  }
}

variable "bigip_password" {
  type = string
}

variable "bigip_address" {
  type = string
}

provider "bigip" {
  address  = var.bigip_address
  username = "admin"
  password = var.bigip_password
}

## This example creates a self-signed certificate for a development

resource "tls_private_key" "example" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "example" {
  key_algorithm   = tls_private_key.example.algorithm
  private_key_pem = tls_private_key.example.private_key_pem


  # Certificate expires after 12 hours.
  validity_period_hours = 12

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]

  dns_names = ["maniak.academy", "maniak.io"]

  subject {
      common_name  = "maniak.academy"
      organization = "Maniak Academy, Inc"
  }
}

resource "bigip_as3"  "as3app1" {
       as3_json = file("as3app1.json")
 }

provider "docker" {
  host = "tcp://localhost:2375/"
}

resource "docker_image" "splunk" {
  name = "splunk/splunk:latest"
}

# Create Splunk container
resource "docker_container" "splunk" {
  image = docker_image.splunk.latest
  name  = "splunk"
  hostname = "splunk"
  env = ["SPLUNK_HTTP_ENABLESSL=true", "SPLUNK_HTTP_ENABLESSL_CERT=cert.pem", "SPLUNK_HTTP_ENABLESSL_PRIVKEY=key.pem", "SPLUNK_HTTP_ENABLESSL_PRIVKEY_PASSWORD=abcd1234", "SPLUNK_PASSWORD=W3lcome098!", "SPLUNK_START_ARGS=--accept-license","SPLUNK_LICENSE_URI=Free", "SPLUNK_HEC_TOKEN=abcd1234" ]
  ports {
    internal = 8000
    external = 8000
  } 
   ports {
    internal = 8088
    external = 8088
  }
}

resource "docker_image" "juice-shop" {
  name = "bkimminich/juice-shop:latest"
}


# Create juicebox container
resource "docker_container" "juice-shop" {
  image = docker_image.juice-shop.latest
  name  = "juice-shop"
  ports {
    internal = 3000
    external = 3001
  }
}

