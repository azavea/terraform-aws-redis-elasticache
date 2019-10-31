variable "project" {
  default = "Unknown"
}

variable "environment" {
  default = "Unknown"
}

variable "vpc_id" {}

variable "vpc_name" {
  description = "Provide vpc name for your region"
}

variable "vpc_tag_name" {}
variable "vpc_tag_value" {}
variable "vpc_subnet_tag_name" {}
variable "vpc_subnet_tag_value" {}

variable "sg_filter_name" {
  default = "description"
}

variable "sg_filter_value" {
  default = ""
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "cache_identifier" {}

variable "parameter_group" {
  default = "default.redis3.2"
}

variable "subnet_group" {
  default = "cloud-elast-19f609hoj8an"
}

variable "maintenance_window" {
}

variable "desired_clusters" {
  default = "1"
}

variable "instance_type" {
  default = "cache.t2.micro"
}

variable "engine_version" {
  default = "3.2.4"
}

variable "automatic_failover_enabled" {
  default = false
}

variable "notification_topic_arn" {
}

variable "alarm_cpu_threshold" {
  default = "75"
}

variable "alarm_memory_threshold" {
  # 10MB
  default = "10000000"
}

variable "alarm_actions" {
  type        = "list"
}
