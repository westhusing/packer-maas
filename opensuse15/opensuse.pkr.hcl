packer {
  required_version = ">= 1.7.0"
  required_plugins {
    qemu = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "filename" {
  type        = string
  default     = "opensuse15.tar.gz"
  description = "The filename of the tarball to produce"
}

variable "opensuse15_iso_path" {
  type    = string
  default = "${env("opensuse15_ISO_PATH")}"
}

source "qemu" "opensuse15" {
  boot_command     = ["<esc><enter><wait>", "linux netdevice=eth0 netsetup=dhcp install=cd:/<wait>", " lang=en_US autoyast=http://{{ .HTTPIP }}:{{ .HTTPPort }}/opensuse15.xml<wait>", " textmode=1<wait>", "<enter><wait>"]
  boot_wait        = "3s"
  communicator     = "none"
  disk_size        = "4G"
  headless         = true
  http_directory   = "http"
  iso_checksum     = "none"
  iso_url          = var.opensuse15_iso_path
  memory           = 4096
  qemuargs         = [["-serial", "stdio"], ["-cpu", "host"]]
  shutdown_timeout = "15m"
}

build {
  sources = ["source.qemu.opensuse15"]

  post-processor "shell-local" {
    inline = [
      "SOURCE=opensuse15",
      "source ../scripts/setup-nbd",
      "ROOT_PARTITION=p2",
      "OUTPUT=${var.filename}",
      "source ../scripts/tar-root"
    ]
    inline_shebang = "/bin/bash -e"
  }
}
