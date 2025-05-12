resource "aws_lb" "alb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.allow_all.id}"]
  subnets            = [aws_subnet.subnet1-public.id, aws_subnet.subnet2-public.id, aws_subnet.subnet3-public.id]
  enable_deletion_protection = false
  tags = {
    Environment = "Production"
  }
}

# Target group for vote service (5000)
resource "aws_lb_target_group" "vote" {
  name     = "vote-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
  health_check {
    path = "/"
    interval = 30
  }
}

# Target group for result service (5001)
resource "aws_lb_target_group" "result" {
  name     = "result-tg"
  port     = 5001
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
  health_check {
    path = "/result"
    interval = 30
  }
}

# Attach ALB to Swarm nodes (replace `aws_instance.swarm_node` with your actual Swarm instances)
resource "aws_lb_target_group_attachment" "vote" {
  count            = 3  # Number of Swarm nodes
  target_group_arn = aws_lb_target_group.vote.arn
  target_id        = aws_instance.web-1[count.index].id  # Assuming Swarm runs on web-1 instances
  port             = 5000
}

resource "aws_lb_target_group_attachment" "result" {
  count            = 3
  target_group_arn = aws_lb_target_group.result.arn
  target_id        = aws_instance.web-1[count.index].id
  port             = 5001
}