# HTTP listener (port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Use /vote or /result"
      status_code  = "200"
    }
  }
}

# Routing rule for /vote → vote:5000
resource "aws_lb_listener_rule" "vote" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vote.arn
  }

  condition {
    path_pattern {
      values = ["/vote*"]
    }
  }
}

# Routing rule for /result → result:5001
resource "aws_lb_listener_rule" "result" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.result.arn
  }

  condition {
    path_pattern {
      values = ["/result*"]
    }
  }
}