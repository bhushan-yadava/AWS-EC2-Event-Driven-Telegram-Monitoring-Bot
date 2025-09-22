variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "secret_name" {
  description = "Name of the AWS Secrets Manager secret storing Telegram token"
}

variable "telegram_chat_id" {
  description = "Telegram chat ID where alerts will be sent"
}

variable "ec2_instance_id" {
  description = "EC2 instance to monitor"
}
