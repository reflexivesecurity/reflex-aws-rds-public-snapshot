module "reflex_aws_rds_public_snapshot" {
  source           = "git::https://github.com/cloudmitigator/reflex-engine.git//modules/cwe_lambda?ref=v0.5.8"
  rule_name        = "RDSPublicSnapshot"
  rule_description = "Rule that alerts when a RDS snapshot is set to be public"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.rds"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "rds.amazonaws.com"
    ],
    "eventName": [
      "ModifyDBSnapshotAttribute"
    ]
  }
}

PATTERN

  function_name   = "RDSPublicSnapshot"
  source_code_dir = "${path.module}/source"
  handler         = "reflex_aws_rds_public_snapshot.lambda_handler"
  lambda_runtime  = "python3.7"
  environment_variable_map = {
    SNS_TOPIC = var.sns_topic_arn,
    
  }



  queue_name    = "RDSPublicSnapshot"
  delay_seconds = 0

  target_id = "RDSPublicSnapshot"

  sns_topic_arn  = var.sns_topic_arn
  sqs_kms_key_id = var.reflex_kms_key_id
}
