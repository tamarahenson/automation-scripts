provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "portainer"
}

resource "aws_instance" "gpuserver" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "g3s.xlarge"
  key_name = "gpu-docker"
  vpc_security_group_ids = [aws_security_group.gpu-sg.id]
  associate_public_ip_address = true

  root_block_device {
  volume_type = "gp2"
  volume_size = "8"
  delete_on_termination = true
  }

  tags = {
  Name = "gpuinstance"
  Environment = "support"
  OS = "ubuntu"
  Managed = "iac"
  }

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing Docker"
  curl -fsSL get.docker.com | CHANNEL=stable sh
  sudo apt install docker-ce
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  echo "*** Completed Installing Docker"
  #echo "*** Installing Portainer"
  #sudo docker run -d -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ee:latest
  #echo "*** Completed Installing Portainer"
  EOF
}

output "gpuinstance" {
  value = aws_instance.gpuserver.public_ip
}


