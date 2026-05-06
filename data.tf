#obtain main VPC
data "aws_vpc" "lab_vpc"{
    filter {
      name = "cidr-block"
      values = ["10.0.0.0/16"]
    }
}

# Get all subnets in the VPC
data "aws_subnets" "all" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.lab_vpc.id]
    }
}

# Por hacer
# Public Subnet 1 (10.0.0.0/24) - AZ A                                                                                
  data "aws_subnet" "public_subnet_1" {                                                                                 
    filter {                                                                                                            
      name   = "cidr-block"                                                                                             
      values = ["10.0.0.0/24"]                                                                                          
    }                                                                                                                   
    filter {                                                                                                            
      name   = "vpc-id"                                                                                                 
      values = [data.aws_vpc.lab_vpc.id]                                                                                
    }                                                                                                                   
  }                                                                                                                     
                                                                                                                        
  # Public Subnet 2 (10.0.1.0/24) - AZ B                                                                                
  data "aws_subnet" "public_subnet_2" {                                                                                 
    filter {                                                                                                            
      name   = "cidr-block"                                                                                             
      values = ["10.0.1.0/24"]                                                                                          
    }                                                                                                                   
    filter {                                                                                                            
      name   = "vpc-id"                                                                                                 
      values = [data.aws_vpc.lab_vpc.id]                                                                                
    }                                                                                                                   
  }                                                                                                                     
                                                                                                                        
  # Private Subnet 1 (10.0.2.0/24) - AZ A                                                                               
  data "aws_subnet" "private_subnet_1" {                                                                                
    filter {                                                                                                            
      name   = "cidr-block"                                                                                             
      values = ["10.0.2.0/24"]                                                                                          
    }                                                                                                                   
    filter {                                                                                                            
      name   = "vpc-id"                                                                                                 
      values = [data.aws_vpc.lab_vpc.id]                                                                                
    }                                                                                                                   
  }                                                                                                                     
                                                                                                                        
  # Private Subnet 2 (10.0.3.0/24) - AZ B                                                                               
  data "aws_subnet" "private_subnet_2" {                                                                                
    filter {                                                                                                            
      name   = "cidr-block"                                                                                             
      values = ["10.0.3.0/24"]                                                                                          
    }                                                                                                                   
    filter {                                                                                                            
      name   = "vpc-id"                                                                                                 
      values = [data.aws_vpc.lab_vpc.id]                                                                                
    }                                                                                                                   
  }                                                                                                                     
                                                                                                                        
  # Get the existing CafeSG security group                                                                              
  data "aws_security_group" "cafe_sg" {                                                                                 
    filter {                                                                                                            
      name   = "tag:Name"                                                                                             
      values = ["CafeSG"]                                                                                               
    }                                                                                                                   
    filter {                                                                                                            
      name   = "vpc-id"                                                                                                 
      values = [data.aws_vpc.lab_vpc.id]                                                                                
    }                                                                                                                   
  }                                                                                                                     
                                                                                                                        
  # Get the existing Cafe WebServer AMI                                                                                 
  data "aws_ami" "cafe_webserver" {                                                                                     
    most_recent = true                                                                                                  
    owners      = ["self"]                                                                                              
                                                                                                                        
    filter {                                                                                                            
      name   = "name"                                                                                                   
      values = ["*Cafe*WebServer*"]                                                                                     
    }                                                                                                                   
  }                                                                                                                     
                                                                                                                        
  # Get the existing CafeRole IAM instance profile                                                                      
  data "aws_iam_instance_profile" "cafe_role" {                                                                         
    name = "CafeRole"                                                                                                   
  }                                                                                                                     
                                                                                                                        
  # Get the route table for Private Subnet 2 (we'll need to update it)                                                  
  data "aws_route_table" "private_subnet_2_rt" {                                                                        
    subnet_id = data.aws_subnet.private_subnet_2.id                                                                     
  } 