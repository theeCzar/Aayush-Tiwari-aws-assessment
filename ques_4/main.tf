provider "aws" {
  region = "us-east-1" 
}

# --- CONFIGURATION ---
locals {
  name_prefix = "Aayush_Tiwari" 
  
  # AWS CloudWatch Billing metrics are typically in USD.
  # $1.20 USD is approximately ₹100 INR.
  alarm_threshold = "1.20" 
  currency        = "USD"
  
  # Enter your email to receive the alert
  my_email        = "aayushtiwari0110@gmail.com" 
}

# --- 1. SNS TOPIC (Notification Channel) ---
resource "aws_sns_topic" "billing_alert_topic" {
  name = "${local.name_prefix}_Billing_Alerts"
}

# --- 2. EMAIL SUBSCRIPTION ---
# Note: After 'terraform apply', you MUST check your inbox 
# and click the confirmation link from AWS.
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.billing_alert_topic.arn
  protocol  = "email"
  endpoint  = local.my_email
}

# --- 3. CLOUDWATCH BILLING ALARM ---
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "${local.name_prefix}_Spend_Limit_Alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600" # Check every 6 hours
  statistic           = "Maximum"
  threshold           = local.alarm_threshold
  alarm_description   = "Alert when bill exceeds threshold"
  actions_enabled     = true
  
  # Send notification to the SNS topic created above
  alarm_actions       = [aws_sns_topic.billing_alert_topic.arn]

  dimensions = {
    Currency = local.currency
  }
}
