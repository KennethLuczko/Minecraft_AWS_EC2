terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}


resource "aws_instance" "minecraftec2" {
  ami                    = data.aws_ami.linux.id
  # t2.micro was not enough resources. t2.medium should support about 5 players.
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.MinecraftRDP.id]
  key_name               = aws_key_pair.deployer.id
    provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt update",
      "sudo apt install openjdk-16-jre-headless -y",
      "mkdir minecraft_server",
      "cd minecraft_server",
      "wget https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar",
      "java -Xms2048M -Xmx2048M -jar server.jar nogui",
      "sed -i 's/false/true/' eula.txt",
      "java -jar server.jar -nogui"
    ]
    connection {
    type     = "ssh"
    user     = "ubuntu"
    host     = aws_instance.minecraftec2.public_ip
    private_key = file("C:/Users/Aphro/.ssh/id_rsa")
      }
    }
}

data "aws_ami" "linux" {
  # if more than 1 resource is returned, use the most recent version
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
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
    description = "EC2 instance connect"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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