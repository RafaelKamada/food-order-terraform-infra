resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.existing.id

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.existing.id

  tags = {
    Name = "Private Route Table"
  }
}

# Se você não estiver usando as associações de route table, pode remover ou comentar
# resource "aws_route_table_association" "public" {
#   count          = 2
#   subnet_id      = data.aws_subnets.public.ids[count.index]
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "private" {
#   count          = 2
#   subnet_id      = data.aws_subnets.private.ids[count.index]
#   route_table_id = aws_route_table.private.id
# }