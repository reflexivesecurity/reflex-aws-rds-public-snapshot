module "cwe" {
  source      = "git::https://github.com/reflexivesecurity/reflex-engine.git//modules/cwe?ref=v2.1.1"
  name        = "RdsPublicSnapshot"
  description = "Rule that alerts when a RDS snapshot is set to be public"

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

}
