
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/20"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-vpc"
  }
}

resource "aws_subnet" "public_us-east-1a" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-public-us-east-1a"
  }
}

resource "aws_subnet" "private_us-east-1a" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-private-us-east-1a"
  }
}

resource "aws_subnet" "public_us-east-1b" {
  cidr_block = "10.0.3.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-public-us-east-1b"
  }
}


resource "aws_subnet" "private_us-east-1b" {
  cidr_block = "10.0.4.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-private-us-east-1b"
  }
}

resource "aws_subnet" "public_us-east-1c" {
  cidr_block = "10.0.5.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1c"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-public-us-east-1c"
  }
}

resource "aws_subnet" "private_us-east-1c" {
  cidr_block = "10.0.6.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1c"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-private-us-east-1c"
  }
}

resource "aws_subnet" "public_us-east-1d" {
  cidr_block = "10.0.7.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1d"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-public-us-east-1d"
  }
}

resource "aws_subnet" "private_us-east-1d" {
  cidr_block = "10.0.8.0/24"
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1d"
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-private-us-east-1d"
  }   
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-igw"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-routetable-public"
    Tier = "public"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.instance_environment}-${var.instance_type}-routetable-private"
    Tier = "private"
  }
}
resource "aws_route_table_association" "public_us-east-1a" {
  subnet_id      = aws_subnet.public_us-east-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_us-east-1a" {
  subnet_id      = aws_subnet.private_us-east-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_us-east-1b" {
  subnet_id      = aws_subnet.public_us-east-1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_us-east-1b" {
  subnet_id      = aws_subnet.private_us-east-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_us-east-1c" {
  subnet_id      = aws_subnet.public_us-east-1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_us-east-1c" {
  subnet_id      = aws_subnet.private_us-east-1c.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "public_us-east-1d" {
  subnet_id      = aws_subnet.public_us-east-1d.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_us-east-1d" {
  subnet_id      = aws_subnet.private_us-east-1d.id
  route_table_id = aws_route_table.private.id
}
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [
    aws_route_table.private.id,
    aws_route_table.public.id
  ]
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
POLICY
  tags = merge(tomap({
    "Name" = "${var.instance_environment}-s3-endpoint"
  }), local.default_tags)
}


