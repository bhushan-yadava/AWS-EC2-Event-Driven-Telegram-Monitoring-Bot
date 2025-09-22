output "lambda_function_name" {
  value = aws_lambda_function.ec2_alert_bot.function_name
}

output "event_rule_name" {
  value = aws_cloudwatch_event_rule.ec2_alarm_rule.name
}
