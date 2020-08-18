variable "access_key" {
    default = "<YOUR ACCESS KEY>"
}

variable "secret_key" {
    default = "<YOUR SECRET KEY>"
}

# Region to be used
variable "region" {
    type = string
    default = "ap-south-1"
}

# AWS instance type to be used
variable "instance_type" {
    type = string
    # default = "t2.medium"
    default = "t2.xlarge"
}

# Userdata section to bootstrap the environment and start the docker containers
variable "userdata" {
  default = <<HEREDOC
  #!/bin/bash
  sudo yum install docker -y
  sudo service docker restart
  sudo sysctl vm.max_map_count=262144
  sudo yum install git -y
  sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  mkdir elk;cd elk
  git clone https://github.com/shankysharma86/Automations.git
  cd Automations/elk-stack/elkcerts/
  bash certgen.sh "mypassword"
  HEREDOC
}
