variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "count_buckets" {
  type    = list(string)
  default = ["count-one", "count-two"]
}

variable "foreach_buckets" {
  type    = set(string)
  default = ["foreach-one", "foreach-two"]
}

variable "foreach_bucket_map" {
  type = map(string)

  default = {
    app  = "app-bucket"
    logs = "logs-bucket"
  }
}