terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}


resource "aws_instance" "minecraftec2" {
  ami                    = data.aws_ami.windows.id
  # need to be at least t2.medium for 4-5 players
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.MinecraftRDP.id]
  key_name               = aws_key_pair.deployer.id
}


data "aws_ami" "windows" {
  # if more than 1 resource is returned, use the most recent version
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  owners = ["amazon"]
}

# 25565 = minecraft ingress port
resource "aws_security_group" "MinecraftRDP" {
  name        = "MinecraftRDP"
  description = "Open ports for RDP and Minecraft"

  ingress {
    description      = "Minecraft"
    from_port        = 25565
    to_port          = 25565
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["24.189.4.150/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDO+cPL7g/sY7fVuzO8wlmvv1qPyWobvmlmS3Jzp4yWSidl/irsHeJWATSK1uF6fUkrJxFYeR6oPg591ejL0EYEU9SwXyGgIw8EtUf4ye40ULfB8fM2nR9mZUtuyQbvKkpsdmGKlW9aEOv61p+xIEcBfDNPUcoGuNQG7uzMyMFdRN0Ci2S5iEwvHqQ/X56WZszpoX3wcr8fYhWiNuoa1fQPeiaSB8nIrKV+ENoN0x51TVWwCF5W2gSynP2pTJWVmbAVPWGYRqq+ciD++AfOCnpOh1h1z1cQ2x2hJdYxGIqa2gFCOzGVJSZxTHfYxTQPlap2sxBwHkSzLlJlOo5x+Ythaw5uqorDUKnttt4RXnlPDtUkrPy3TW0M/XEEMgMeSwhdGu5XP+edPcHoS6k/NQQeogPcTPngf2wKtxwZFXRjaaj3RtfHS40yA9MHDREjHEceiBM0IgnAhhgMTnvawDLWneJ+UCKUc+4rW15rR8SkbMfz5zcNAyIxXpGQPQyV55E= aphro@DESKTOP-MBKSTL4"
}

