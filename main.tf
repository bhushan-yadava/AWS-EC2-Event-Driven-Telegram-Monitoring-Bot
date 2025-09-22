provider "aws" {
  region = var.region
}

# Package Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda/handler.py"
  output_path = "../lambda/handler.zip"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "ec2-telegram-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach basic Lambda execution role
resource "aws_iam_policy_attachment" "lambda_basic" {
  name       = "lambda-basic-attach"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "ec2_alert_bot" {
  function_name = "ec2-telegram-alert"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.9"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SECRET_NAME      = var.secret_name
      TELEGRAM_CHAT_ID = var.telegram_chat_id
    }
  }
}

# EventBridge Rule for CloudWatch alarms
resource "aws_cloudwatch_event_rule" "ec2_alarm_rule" {
  name        = "ec2-alarm-rule"
  description = "EventBridge rule for EC2 alarms"
  event_pattern = jsonencode({
    "source" : ["aws.cloudwatch"],
    "detail-type" : ["CloudWatch Alarm State Change"]
  })
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "send_to_lambda" {
  rule      = aws_cloudwatch_event_rule.ec2_alarm_rule.name
  target_id = "ec2-lambda"
  arn       = aws_lambda_function.ec2_alert_bot.arn
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_alert_bot.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_alarm_rule.arn
}

# ----------------------------
# Sample CloudWatch Alarm
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  alarm_name          = "ec2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when EC2 CPU exceeds 80%"
  dimensions = {
    InstanceId = var.ec2_instance_id
  }

  # Send alarm to EventBridge
  alarm_actions = []
}
