# SNS to SQS with DLQ

This project allows to create a SQS queue with DLQ and subscribe it to a SNS topic.

Currently, it does not support cross region subscription. [Link to issue](https://github.com/hashicorp/terraform/issues/24476).

There's an example on how to use it:

```terraform
module "my_new_queue" {
  source = "git@github.com:dev-clubbi/terraform-sns-sqs-with-dlq.git"
  queue_name = "${local.prefix}my-new-queue-queue"
  region = var.region
  topics = [{name=local.my_topic_of_interest_arn, raw_message_delivery=true}]
  filter_policy = {"some_attribute_of_message": ["acceptable_value", "another_one"]}
  tags = {
    "name": "my-new-queue-queue",
    "environment": local.environment,
    "service": local.project
  }
  environment = local.environment
  prefix = local.prefix
  cloudwatch_alarm_name = "alerts_ops"
}
```

- The `topics[n].name` var can be an ARN string as well as a topic name string.
- The `filter_policy` will only work when the key-value pair is contained inside SQS message attributes. It will **NOT** work if the key-value is inside the message.
