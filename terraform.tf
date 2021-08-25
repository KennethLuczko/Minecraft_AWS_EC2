terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


resource "aws_instance" "minecraftec2" {
  for_each = {
    MICRO  = "t2.micro"
    MEDIUM = "t2.medium"
  }
  tags = {
    Name = "MC-SERVER-${each.key}"
  }

  ami                    = data.aws_ami.filtered_ami.id
  instance_type          = each.value
  vpc_security_group_ids = [aws_security_group.MinecraftRDP.id]
  key_name               = aws_key_pair.deployer.id
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt update",
      "sudo apt install ${var.latest_java_version} -y",
      "mkdir ${var.minecraft_server_directory_name}",
      "cd ${var.minecraft_server_directory_name}",
      "wget ${var.latest_minecraft_version}",
      "java -Xms${var.ram_allocation}M -Xmx${var.ram_allocation}M -jar server.jar nogui",
      "sed -i 's/false/true/' eula.txt",
      "java -jar server.jar -nogui"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.private_key_directory)
    }
  }
}

data "aws_ami" "filtered_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_filter_value]
  }
  owners = [var.ami_filter_owners]
}

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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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
  public_key = var.deployer_public_key
}