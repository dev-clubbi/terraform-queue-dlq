resource "aws_sns_topic" "cloud_watch_alarms" {
  name = "${var.prefix}alerts_ops"
  tags = var.tags
}

resource "aws_sqs_queue" "dlq" {
  name = "${var.queue_name}_dlq"
}

resource "aws_sqs_queue" "queue" {
  depends_on = [
    aws_sqs_queue.dlq
  ]
  name           = var.queue_name
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_retry
  })
  tags = var.tags
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "subscription" {
  for_each  = {for vm in var.topics :  vm.name => vm}
  source    = "./subscription"
  topic_arn = join("",
    [
      can(regex("^arn:aws:sns", each.value.name)) ?
      each.value.name :
      "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${each.value.name}"
    ]
  )
  queue_name           = aws_sqs_queue.queue.name
  raw_message_delivery = each.value.raw_message_delivery
  depends_on           = [aws_sqs_queue.queue]
  filter_policy = var.filter_policy
}

resource "aws_cloudwatch_metric_alarm" "create_order_dlq_error" {
  alarm_name = "${aws_sqs_queue.dlq.name}_alarm"
  actions_enabled = var.environment == "production" ? true: false
  alarm_description = "Dead letter QUEUE should be empty"
  tags = var.tags
  namespace = "AWS/SQS"
  metric_name = "ApproximateNumberOfMessagesVisible"
  statistic = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold = 0
  period = 60
  dimensions = {
    QueueName = aws_sqs_queue.dlq.name
  }
  alarm_actions = [
    aws_sns_topic.cloud_watch_alarms.arn
  ]
  evaluation_periods = 1
  count = var.environment == "local" ? 0: 1
}
