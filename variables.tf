variable "vpc_cidr" {
  description = "Terraform Deploy: The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Terraform Deploy: The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_prim" {
  description = "Terraform Deploy: The CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_stby" {
  description = "Terraform Deploy: The CIDR block for the private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone" {
  description = "Terraform Deploy: The availability zone for the subnets"
  type        = string
  default     = "eu-west-1a"
}

variable "private_availability_zone_prim" {
  description = "Terraform Deploy: The availability zone for the private subnet"
  type        = string
  default     = "eu-west-1b"
}
variable "private_availability_zone_stby" {
  description = "Terraform Deploy: The availability zone for the private subnet"
  type        = string
  default     = "eu-west-1c"
}


variable "db_sg_name" {
  description = "Terraform Deploy: The name of the database security group"
  type        = string
  default     = "db_sg"
}

variable "app_sg_name" {
  description = "Terraform Deploy: The name of the application security group"
  type        = string
  default     = "app_sg"
}

variable "db_sg_description" {
  description = "Terraform Deploy: The description of the database security group"
  type        = string
  default     = "Security group for database subnet"
}

variable "app_sg_description" {
  description = "Terraform Deploy: The description of the application security group"
  type        = string
  default     = "Security group for application subnet"
}

variable "db_sg_tag_name" {
  description = "Terraform Deploy: The tag name for the database security group"
  type        = string
  default     = "db_sg"
}

variable "app_sg_tag_name" {
  description = "Terraform Deploy: The tag name for the application security group"
  type        = string
  default     = "app_sg"
}

