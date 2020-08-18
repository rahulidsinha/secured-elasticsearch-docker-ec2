resource "aws_vpc" "elasticsearch-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support= true
    enable_dns_hostnames = true
    tags = {
        type = "terraformed"
    }
}

resource "aws_subnet" "elasticsearch-public-subnet" {
    vpc_id = aws_vpc.elasticsearch-vpc.id
    availability_zone = "ap-south-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
        type = "terraformed"
    }
}

resource "aws_internet_gateway" "elasticsearch-igw" {
    vpc_id = aws_vpc.elasticsearch-vpc.id
}

resource "aws_route_table" "elasticsearch-rt" {
    vpc_id = aws_vpc.elasticsearch-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.elasticsearch-igw.id
    }
    tags = {
        type = "terraformed"
    }
}
resource "aws_route_table_association" "elasticsearch-rt-association" {
    subnet_id = aws_subnet.elasticsearch-public-subnet.id
    route_table_id = aws_route_table.elasticsearch-rt.id
}
resource "aws_network_acl" "elasticsearch-nacl" {
    vpc_id = aws_vpc.elasticsearch-vpc.id
    subnet_ids = [aws_subnet.elasticsearch-public-subnet.id]
    ingress {
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
        protocol = "-1"
        rule_no = 100
        action = "allow"
    }
    egress {
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
        protocol = "-1"
        rule_no = 200
        action = "allow"
    }
}

resource "aws_security_group" "elasticsearch-sg" {
    vpc_id = aws_vpc.elasticsearch-vpc.id
    name = "elasticsearch-sg" 
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 9200
        to_port = 9200
        protocol = "tcp"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 5601
        to_port = 5601
        protocol = "tcp"
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 5044
        to_port = 5044
        protocol = "tcp"
    }
    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        type = "terraformed"
    }
}
