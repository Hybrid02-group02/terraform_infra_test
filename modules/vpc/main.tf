# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
  }
}

# # NAT 게이트웨이용 EIP
# resource "aws_eip" "nat_eip" {
#   count = 1
#   domain = "vpc"
#   tags = {
#     Name = "${var.project_name}-nat-eip"
#   }
# }

# # NAT 게이트웨이 생성
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip[0].id
#   subnet_id     = aws_subnet.public[0].id

#   tags = {
#     Name = "${var.project_name}-nat"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

resource "aws_eip" "nat_eip" {
  count  = length(var.azs)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.igw]
}


# 퍼블릭 라우트 테이블 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# 프라이빗 라우트 테이블 생성
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "${var.project_name}-private-rt"
#   }
# }

# 퍼블릭 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 프라이빗 서브넷과 라우트 테이블 연결
# resource "aws_route_table_association" "private" {
#   count          = length(aws_subnet.private)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

# Network ACL 생성
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-network-acl"
  }
}

resource "aws_network_acl_rule" "allow_icmp" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 150
  egress         = false
  protocol       = "icmp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 8     # Echo Request
  to_port        = -1    # 모든 코드 허용
}

# HTTP (80) 허용
resource "aws_network_acl_rule" "allow_http" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# HTTPS (443) 허용
resource "aws_network_acl_rule" "allow_https" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# SSH (22) 허용
resource "aws_network_acl_rule" "allow_ssh" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# 아웃바운드 전부 허용
resource "aws_network_acl_rule" "allow_outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# 퍼블릭 서브넷에 NACL 연결
resource "aws_network_acl_association" "public" {
  count          = length(aws_subnet.public)
  network_acl_id = aws_network_acl.main.id
  subnet_id      = aws_subnet.public[count.index].id
}


# 프라이빗 서브넷 보안 그룹 생성 (HTTPS 아웃바운드 허용)
resource "aws_security_group" "private_sg" {
  name        = "${var.project_name}-private-sg"
  description = "Security group for private subnet"
  vpc_id      = aws_vpc.main.id

  # 🔐 Kubelet, Metrics, Node 간 통신 (예: Prometheus → Kubelet)
  ingress {
    from_port   = 10250
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]  # 또는 노드들이 있는 서브넷 CIDR
  }

  # 🌐 OpenShift NodePort 서비스용 (사용자 트래픽을 워커 노드로 전달)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # 🔧 SSH 접근 허용 (운영자 관리 목적, bastion 또는 관리용 IP에서 접근)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # 📡 Kubernetes API 서버와 통신 (클러스터 내 노드들이 API와 통신)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # 🧱 MachineConfig Server (ROSA가 워커 노드 초기 설정 시 사용)
  ingress {
    from_port   = 22623
    to_port     = 22623
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]  # 모든 외부 URL에 대한 액세스를 허용
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "${var.project_name}-private-sg"
  }
}

# resource "aws_network_interface" "private" {
#   count              = length(aws_subnet.private)
#   subnet_id          = aws_subnet.private[count.index].id
#   private_ips        = [count.index == 0 ? "10.0.101.10" : "10.0.102.10"]
#   security_groups    = [aws_security_group.private_sg.id]

#   tags = {
#     Name = "Private Network Interface ${count.index + 1}"
#   }
# }

# 프라이빗 라우트 테이블 생성
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

