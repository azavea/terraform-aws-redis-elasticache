variable "vpc_id" { }
variable "vpc_cidr_block" { }

variable "engine_version" {
  default = "2.8.22"
}
variable "instance_type" {
  default = "cache.t2.micro"
}
variable "maintenance_window" {
  # SUN 01:00AM-02:00AM ET
  default = "sun:05:00-sun:06:00"
}

variable "private_subnet_ids" { }

variable "alarm_actions" { }
