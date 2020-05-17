module "cwe" {
  source      = "git::https://github.com/cloudmitigator/reflex-engine.git//modules/cwe_lambda?ref=v0.6.0"
  name        = "RDSPublicSnapshot"
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
