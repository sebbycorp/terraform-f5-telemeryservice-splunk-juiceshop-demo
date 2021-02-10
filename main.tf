terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
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

