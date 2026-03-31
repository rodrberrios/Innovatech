
#Grupo de seguridad para el frontend, permitiendo HTTP desde internet y SSH para administración
resource "aws_security_group" "sg_frontend" {
  name = "innovatech-sg-frontend"
  description = "Frontend: HTTP publico + SSH admin"
  vpc_id = aws_vpc.main.id

  #puerto 80 es http
  ingress {
    description = "HTTP desde internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  #puerto 22 es SSH
  ingress {
    description = "SSH administracion"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  # Acepta HTTP desde Internet y SSH para administracion


  tags = {
    Name = "innovatech-sg-frontend"
  }
}

#grupo de seguridad para el backend, permitiendo solo tráfico desde el frontend
resource "aws_security_group" "sg_backend" {
  name = "innovatech-sg-backend"
  description = "Backend: Solo acceso desde Frontend"
  vpc_id = aws_vpc.main.id

  ingress{
    description = "App desde Frontend"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [aws_security_group.sg_frontend.id]
  }

  ingress{
    description = "SSH desde Frontend"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Innovatech-sg-backend"
  }
}


#grupo de seguridad para la base de datos, permitiendo solo tráfico desde el backend
resource "aws_security_group" "sg_data" {
  name = "innovatech-sg-data"
  description = "Data MySQL: Solo acceso desde Backend"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "DB desde Backend"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.sg_backend.id]
  }

  ingress{
    description = "SSH desde Backend"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.sg_backend.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Innovatech-sg-data"

  }
}