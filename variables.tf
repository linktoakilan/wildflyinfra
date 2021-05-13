variable "vpc_name" {
  type    = string
  default = "demo_vpc"

}
variable "vpccidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "enable_dns_hostname" {
  type    = bool
  default = "false"

}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}
variable "pubsub_name" {
  type    = list(string)
  default = ["pubsub-1a", "pubsub-1b", "pubsub-1c"]

}
variable "prisub_name" {
  type    = list(string)
  default = ["prisub-1a", "prisub-1b", "prisub-1c"]

}
variable "pubsub_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}
variable "prisub_cidr" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

}

variable "igwname" {
  type    = string
  default = "Internet gateway"
}