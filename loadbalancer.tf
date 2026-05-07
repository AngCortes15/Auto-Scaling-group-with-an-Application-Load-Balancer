resource "aws_security_group" "alb_sg" {
  name =         "${var.project_name}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id = data.aws_vpc.lab_vpc.id

  ingress  {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer in the two public subnets
resource "aws_lb" "cafe_alb" {
  name =        "${var.project_name}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [ 
    data.aws_subnet.public_subnet_1.id,
    data.aws_subnet.public_subnet_2.id
   ]

   lifecycle {     
    ignore_changes = all
    }
}

# Target group for the application web servers
resource "aws_lb_target_group" "cafe_tg" {
    name = "${var.project_name}-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.lab_vpc.id

    health_check {
      path                  = "/cafe"
      healthy_threshold     = 2
      unhealthy_threshold   = 2
      interval              = 30 
    }   
}

# ALB listener - forwards HTTP traffic to the target group
resource "aws_lb_listener" "cafe_listener" {
  load_balancer_arn = aws_lb.cafe_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.cafe_tg.arn
  }
}

# Attach the target group to the Auto Sacaling Group
resource "aws_autoscaling_attachment" "cafe_asg_attachment" {
    autoscaling_group_name = aws_autoscaling_group.cafe_asg.name
    lb_target_group_arn = aws_lb_target_group.cafe_tg.arn
  
}

