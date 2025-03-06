variable "region" {
  description = "Region where the resources will be created"
  type        = string
  default     = "ap-south-1" # Replace with your desired Region
}

variable "jenkins_master_ami" {
  description = "AMI for Jenkins Master"
  type        = string
  default     = "ami-00bb6a80f01f03502" # Replace with your desired AMI
}

variable "jenkins_agent_ami" {
  description = "AMI for Jenkins Agent"
  type        = string
  default     = "ami-00bb6a80f01f03502" # Replace with your desired AMI
}

variable "jenkins_master_instance_type" {
  description = "Instance type for Jenkins Master and Agent"
  type        = string
  default     = "t2.micro"
}

variable "jenkins_agent_instance_type" {
  description = "Instance type for Jenkins Master and Agent"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "adithya" # Replace with your key pair name
}

variable "jenkins_master_name" {
  description = "Name tag for Jenkins Master instance"
  type        = string
  default     = "Jenkins-Master"
}

variable "jenkins_agent_name" {
  description = "Name tag for Jenkins Agent instance"
  type        = string
  default     = "Jenkins-Agent"
}