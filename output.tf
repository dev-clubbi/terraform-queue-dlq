output "queue_arn" {
  description = "The ARN of the Queue"
  value       = aws_sqs_queue.queue.arn
  sensitive   = true
}

output "dlq_queue_arn" {
  description = "The ARN of the DLQ Queue"
  value       = aws_sqs_queue.dlq.arn
  sensitive   = true
}

output "queue_url" {
  description = "The URL of the Queue"
  value       = aws_sqs_queue.queue.url
  sensitive   = true
}

output "dlq_queue_url" {
  description = "The URL of the DLQ Queue"
  value       = aws_sqs_queue.dlq.url
  sensitive   = true
}
