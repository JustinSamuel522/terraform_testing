terraform{
 required_providers {
   aws = {
    source = "hashicorp/aws"
    version = "~> 4.16"
   }
 }
 required_version = ">=1.2.0"
}

provider "aws" {
    region = "us-west-2"
    access_key = ""
    secret_key=""
}

resource "aws_instance" "example" {
  ami                    = "ami-0e731c8a588258d0d" 
  instance_type          = "t2.micro"
  key_name               = "JonO"
  vpc_security_group_ids = ["sg-0f47fb468827323df"]
  tags = {
    Name = "html project"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "mkdir project",
      "cd project",
      "sudo yum install git -y",
      "git clone https://github.com/JustinSamuel522/terraform_testing.git",
      "cd test",
      "sudo yum install -y python3", # Installing Python 3
      "cd ~/project/test",
      "nohup python3 -m http.server 8000 &" # Starting a simple HTTP server in the background
      # Access your helloWorld.html at http://<server-ip>:8000/helloWorld.html

      # Note: Ensure you have helloWorld.html in the repository.
    ]
    
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = base64decode(var.private_key_base64)
      host        = self.public_ip
    }
  }
}

variable "private_key_base64" {
  description = "Base64 encoded private key content"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
}