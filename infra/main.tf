

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

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "innovatech-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "innovatech-nat"
  }

  depends_on = [ aws_internet_gateway.igw]
}

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

output "frontend_public_ip" {
  description = "IP pública del Frontend"
  value       = aws_instance.frontend.public_ip
}

output "backend_private_ip" {
  description = "IP privada del Backend"
  value       = aws_instance.backend.private_ip
}

output "data_private_ip" {
  description = "IP privada de Data"
  value       = aws_instance.data.private_ip
}