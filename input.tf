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
    max_retry            = number
  }))
  default = [
    {
      name                 = "teste-ale-cloudwatch"
      raw_message_delivery = true
      max_retry            = 2
    }
  ]
}

variable "max_retry" {
  type    = number
  default = 3
}