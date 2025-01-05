resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-instance-sg"
  }
}

resource "aws_instance" "db_instance" {
  ami           = "ami-0e2c8caa4b6378d8c" # Replace with a valid Ubuntu AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[0].id
  key_name               = "MyKeyPair"
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "db-instance"
  }
}

