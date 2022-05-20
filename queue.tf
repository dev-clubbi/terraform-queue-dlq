resource "aws_sqs_queue" "dql" {
  name = "${var.queue_name}_dlq"
  #  tags = local.tags
}

resource "aws_sqs_queue" "queue" {
  depends_on = [
    aws_sqs_queue.dql
  ]
  name           = "${var.queue_name}"
  #  tags           = local.tags
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dql.arn
    maxReceiveCount     = var.max_retry
  })
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "subscription" {
  for_each  = {for vm in var.topics :  vm.name => vm}
  source    = "./subscription"
  topic_arn = join("",
    [
      "arn:aws:sns:${data.aws_region.current.name}",
      ":${data.aws_caller_identity.current.account_id}:",
      each.value.name
    ]
  )
  queue_name           = aws_sqs_queue.queue.name
  raw_message_delivery = each.value.raw_message_delivery
  depends_on           = [aws_sqs_queue.queue]
}

