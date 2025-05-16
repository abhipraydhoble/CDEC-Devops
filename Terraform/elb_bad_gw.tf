
# create security group

resource "aws_security_group" "firewall" {
    name_prefix = "web-sg"
    vpc_id = "vpc-0b513c39beed873c2"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "web-sg"
    }

}

#  create launch template for asg

resource "aws_launch_template" "test" {
    name = "elb-launch-temp"

    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.key
    vpc_security_group_ids = [aws_security_group.firewall.id]

    user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo "Hi Welcome to Home Page" > /var/www/html/index.html
    mkdir -p /var/www/html/mobile
    echo "Hello This is Mobile App" > /var/www/html/mobile/index.html
    mkdir -p /var/www/html/laptop
    echo "Hello This is Laptop App" >/var/www/html/laptop/index.html
    EOF
    )
    lifecycle {
      create_before_destroy = true
    }
}

# Auto scaling group 
resource "aws_autoscaling_group" "asg" {
    launch_template {
      id = aws_launch_template.test.id
      version = "$Latest"
    }

    vpc_zone_identifier = ["subnet-05bda144578ea9914", "subnet-0b6e1ae4003ff61b3"]
    desired_capacity = 2
    min_size = 1
    max_size = 3

    health_check_type = "EC2"
    health_check_grace_period = 300

    target_group_arns = [
        aws_lb_target_group.tg_home.arn,
        aws_lb_target_group.tg_laptop.arn,
        aws_lb_target_group.tg_mobile.arn
    ]
    tag {
      key = "Name"
      value = "test-asg"
      propagate_at_launch = true
    }
  
}


# create target group

resource "aws_lb_target_group" "tg_home" {
    name = "tg-home"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-0b513c39beed873c2"

    health_check {
      path = "/"
      port = 80
      protocol = "HTTP"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group" "tg_mobile" {
    name = "tg-mobile"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-0b513c39beed873c2"

    health_check {
      path = "/mobile/"
      port = 80
      protocol = "HTTP"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group" "tg_laptop" {
    name = "tg-laptop"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-0b513c39beed873c2"

    health_check {
      path = "/laptop/"
      port = 80
      protocol = "HTTP"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

# create load balancer
resource "aws_lb" "test-lb" {
    name = "test-lb"
    internal = false 
    load_balancer_type = "application"
    security_groups = [aws_security_group.firewall.id]
    subnets = ["subnet-05bda144578ea9914", "subnet-0b6e1ae4003ff61b3"]
     tags = {
        Name = "test-lb"
     }
}

resource "aws_lb_listener" "list-1" {
    load_balancer_arn = aws_lb.test-lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg_home.arn
    }
  
}


resource "aws_lb_listener_rule" "myrule" {
    listener_arn = aws_lb_listener.list-1.arn
    priority = 1 
    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg_laptop.arn
    }
    condition {
      path_pattern {
        values = ["/laptop/*"]
      }
    }
  
}

resource "aws_lb_listener_rule" "myrule-2" {
    listener_arn = aws_lb_listener.list-1.arn
    priority = 2
    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg_mobile.arn
    }
    condition {
      path_pattern {
        values = ["/mobile/*"]
      }
    }
  
}
