resource "aws_launch_template" "cafe_lt" {
    name        = "${var.project_name}-launch-template"
    image_id    = data.aws_ami.cafe_webserver.id 
    instance_type = "t2.micro"

    iam_instance_profile { # IAM settings
      name = data.aws_iam_instance_profile.cafe_role.name
    }

    network_interfaces { #network settings
      associate_public_ip_address = false
      security_groups = [data.aws_security_group.cafe_sg.id]
    }
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "webserver"
      }
    }
}