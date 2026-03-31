
#ip fija para el NAT
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "innovatech-nat-eip"
  }
}

#NAT Gateway en subred pública
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "innovatech-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

#Rutas para subredes privadas, salen por NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "innovatech-rt-private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "subnet_publica_id" {
  description = "ID subred pública (Frontend)"
  value       = aws_subnet.public.id
}

output "subnet_privada_id" {
  description = "ID subred privada (Backend + Data)"
  value       = aws_subnet.private.id
}


#esto crea la vpc con el nombre main, llama a la funcion aws_vpc, y le asigna un bloque CIDR de 10.0.0.0/16, ademas de habilitar los hostnames y el soporte DNS. Finalmente, le asigna una etiqueta con el nombre innovatech-vpc.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "innovatech-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "innovatech-subnet-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "innovatech-subnet-private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "innovatech-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "innovatech-rt-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}