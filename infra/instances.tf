# EC2 Capa 1: Frontend (subred pública)
resource "aws_instance" "frontend" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]
  key_name               = "innovatech-key"

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y docker git nginx
    systemctl enable docker nginx
    systemctl start docker nginx
    usermod -aG docker ec2-user
  EOF

  tags = { Name = "innovatech-frontend" }
}

# EC2 Capa 2: Backend (subred privada)
resource "aws_instance" "backend" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.sg_backend.id]
  key_name               = "innovatech-key"

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y docker git
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
  EOF

  tags = { Name = "innovatech-backend" }
}

# EC2 Capa 3: Data (subred privada)
resource "aws_instance" "data" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.sg_data.id]
  key_name               = "innovatech-key"

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y docker git
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
    # MySQL correrá como contenedor Docker en la fase 2
    # Por ahora dejamos la instancia lista con Docker instalado
  EOF

  tags = { Name = "innovatech-data" }
}