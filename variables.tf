variable "minecraft_server_directory_name" {
  type        = string
  default     = "minecraft_server"
  description = "Directory name"
}

variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region"
}

variable "latest_java_version" {
  type        = string
  default     = "openjdk-16-jre-headless"
  description = "The most up-to-date Java version package to install"
}

variable "latest_minecraft_version" {
  type        = string
  default     = "https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar"
  description = "The most up-to-date Minecraft server jar version to install"
}

variable "ram_allocation" {
  type        = number
  default     = "2048"
  description = "Ram allocation size. Example: 1024, 2048 ..."
}

variable "private_key_directory" {
  type        = string
  default     = "C:/Users/Aphro/.ssh/id_rsa"
  description = "Directory which contains a private key"
}

variable "ami_filter_value" {
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  description = "AMI filter value"
}

variable "ami_filter_owners" {
  type        = string
  default     = "099720109477"
  description = "AMI filter owners"
}

variable "deployer_public_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDO+cPL7g/sY7fVuzO8wlmvv1qPyWobvmlmS3Jzp4yWSidl/irsHeJWATSK1uF6fUkrJxFYeR6oPg591ejL0EYEU9SwXyGgIw8EtUf4ye40ULfB8fM2nR9mZUtuyQbvKkpsdmGKlW9aEOv61p+xIEcBfDNPUcoGuNQG7uzMyMFdRN0Ci2S5iEwvHqQ/X56WZszpoX3wcr8fYhWiNuoa1fQPeiaSB8nIrKV+ENoN0x51TVWwCF5W2gSynP2pTJWVmbAVPWGYRqq+ciD++AfOCnpOh1h1z1cQ2x2hJdYxGIqa2gFCOzGVJSZxTHfYxTQPlap2sxBwHkSzLlJlOo5x+Ythaw5uqorDUKnttt4RXnlPDtUkrPy3TW0M/XEEMgMeSwhdGu5XP+edPcHoS6k/NQQeogPcTPngf2wKtxwZFXRjaaj3RtfHS40yA9MHDREjHEceiBM0IgnAhhgMTnvawDLWneJ+UCKUc+4rW15rR8SkbMfz5zcNAyIxXpGQPQyV55E= aphro@DESKTOP-MBKSTL4"
  description = "Public key"
}