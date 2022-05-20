data aws_sqs_queue queue {
  name = var.queue_name
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = data.aws_sqs_queue.queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${data.aws_sqs_queue.queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.topic_arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "subscription" {
  endpoint             = data.aws_sqs_queue.queue.arn
  protocol             = "sqs"
  topic_arn            = var.topic_arn
  raw_message_delivery = var.raw_message_delivery
}