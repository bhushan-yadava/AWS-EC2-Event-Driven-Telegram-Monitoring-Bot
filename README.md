## 🚀 AWS EC2 Event-Driven Telegram Monitoring Bot 🚀

Automating EC2 health checks and notifications using an event-driven architecture integrated with Telegram.
This bot delivers real-time alerts (EC2 health checks, CPU spikes, connectivity issues, etc.) directly to Telegram, with optional quick actions like instance reboot or description queries.

## 📌 Architecture
Core Flow

CloudWatch → EventBridge → Lambda → Telegram

Extended (Enterprise Ready)

Secrets Manager → Stores Telegram bot token securely

IAM → Enforces least-privilege access for Lambda actions

CloudTrail → Logs all actions for auditing and compliance

## 👉 Architecture Diagram:

##⚡ Features

✅ Event-driven monitoring – instant notifications from CloudWatch alarms

✅ Telegram Bot integration – mobile-first alerting system

✅ Custom inline commands – /describe, /reboot for quick actions

✅ Secure secret storage – Telegram bot token managed via AWS Secrets Manager

✅ Least-privilege IAM – only necessary permissions granted

✅ Audit-friendly logging – via CloudWatch Logs & CloudTrail

✅ Easily extensible – add Slack, Opsgenie, or custom runbooks

## 🛠️ Tech Stack

AWS Services: CloudWatch, EventBridge, Lambda, Secrets Manager, IAM, CloudTrail

Language: Python (boto3, requests)

Messaging: Telegram Bot API

Infrastructure as Code: Terraform / CloudFormation

CI/CD: GitHub Actions for automated Lambda deployments

##🚀 Getting Started

1. Prerequisites

AWS Account with permissions for EC2, Lambda, EventBridge, CloudWatch, Secrets Manager

Telegram account and a bot token (create via BotFather
)

Terraform / AWS CLI configured locally

2. Setup Instructions
🔹 Step 1: Create a Telegram Bot

Open Telegram and talk to BotFather.

Create a new bot and copy the bot token.

Store the token in AWS Secrets Manager:

aws secretsmanager create-secret \
  --name TelegramBotToken \
  --secret-string "YOUR_BOT_TOKEN"

🔹 Step 2: Deploy AWS Infrastructure

Using Terraform (example):

terraform init
terraform apply


This will create:

CloudWatch Alarms

EventBridge Rule

Lambda Function

IAM Roles/Policies

🔹 Step 3: Configure Lambda

Update Lambda environment variables


## 🔐 Security Best Practices

Use Secrets Manager for API tokens

Apply least-privilege IAM policies for Lambda

Enable CloudTrail logging for all API calls

Rotate secrets regularly

## 📈 Future Enhancements

Add Slack / Opsgenie integration

Support multiple EC2 event types (start/stop/reboot)

Add auto-remediation workflows (restart unhealthy instances)

Dashboard integration with Grafana

## 🤝 Contributing

Contributions are welcome! Please open issues and PRs to improve the project.

SECRET_NAME=TelegramBotToken

TELEGRAM_CHAT_ID=your_chat_id
