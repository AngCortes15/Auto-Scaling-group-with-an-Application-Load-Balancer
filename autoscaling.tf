resource "aws_autoscaling_group" "cafe_asg" {
    name = "${var.project_name}-asg"
    desired_capacity = 2
    min_size = 2
    max_size = 6
    vpc_zone_identifier = [  #Deploys instances across private subnets (one per zone)
        data.aws_subnet.private_subnet_1.id,
        data.aws_subnet.private_subnet_2.id
     ]

    launch_template {
      id = aws_launch_template.cafe_lt.id
      version = "$Latest"
    }
    
    tag { 
      key = "Name"
      value = "webserver"
      propagate_at_launch = true # Tags the EC2 instances with Name = webserver
    }
}

resource "aws_autoscaling_policy" "cafe_cpu_policy" {
    name        = "${var.project_name}-cpu-tracking"
    autoscaling_group_name = aws_autoscaling_group.cafe_asg.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {                                                                                              
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value       = 25.0
        disable_scale_in   = false                                                                                                     
    } 
}