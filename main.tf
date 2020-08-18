provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_eip" "elasticsearch-eip" {
    instance = aws_instance.elasticsearch-instance.id
    vpc = true
}

resource "aws_key_pair" "pub-key" {
    key_name = "my_key"
    public_key = "<Public key>"
}

resource "aws_instance" "elasticsearch-instance" {
    ami = "ami-0b5bff6d9495eff69"
    instance_type = var.instance_type
    subnet_id = aws_subnet.elasticsearch-public-subnet.id
    user_data = var.userdata 
    security_groups = [aws_security_group.elasticsearch-sg.id]
    root_block_device {
       volume_size = 10
    }
    key_name = aws_key_pair.pub-key.key_name 
    tags = {
        type = "terraformed"
    }
}

