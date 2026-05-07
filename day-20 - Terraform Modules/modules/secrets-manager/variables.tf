variable "name_prefix" {
  type = string
}

variable "create_db_secret" {
  type    = bool
  default = false
}

variable "create_api_secret" {
  type    = bool
  default = false
}

variable "create_app_config_secret" {
  type    = bool
  default = false
}

variable "db_username" {
  type      = string
  default   = ""
  sensitive = true
}

variable "db_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_host" {
  type    = string
  default = ""
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "db_name" {
  type    = string
  default = ""
}

variable "api_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "api_secret" {
  type      = string
  default   = ""
  sensitive = true
}

variable "app_config" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}