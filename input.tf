variable region {
  type    = string
  default = ""
}

variable "queue_name" {
  type = string
}

variable "topics" {
  type = list(object({
    name                 = string
    raw_message_delivery = bool
  }))
  default = []
}

variable "max_retry" {
  type    = number
  default = 3
}