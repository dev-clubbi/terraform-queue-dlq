variable queue_name {
  type = string
}

variable topic_arn {
  type = string
}

variable "topic_region" {
  type    = string
  default = ""
}

variable "raw_message_delivery" {
  type    = bool
  default = true
}

variable "filter_policy" {
  type = object({})
  default = {}
}