""" Module for RDSPublicSnapshot """

import json
import os

import boto3
from reflex_core import AWSRule, subscription_confirmation


class RDSPublicSnapshot(AWSRule):
    """ Rule to detect the setting of an RDS snapshot to be shared publicly """

    def __init__(self, event):
        super().__init__(event)

    def extract_event_data(self, event):
        """ Extract required event data """
        self.snapshot_id = event["detail"]["requestParameters"]["dBSnapshotIdentifier"]
        self.request_params = event["detail"]["requestParameters"]

    def resource_compliant(self):
        """
        Determine if the resource is compliant with your rule.

        Return True if it is compliant, and False if it is not.
        """
        if self.request_params["attributeName"] == "restore":
            if "all" in self.request_params["valuesToAdd"]:
                return False
        return True

    def remediate(self):
        """ Fix the non-compliant resource """
        self.set_snapshot_private()

    def set_snapshot_private(self):
        self.client.modify_db_snapshot_attribute(
            DBSnapshotIdentifier=self.snapshot_id,
            AttributeName="restore",
            ValuesToRemove=["all"],
        )

    def get_remediation_message(self):
        """ Returns a message about the remediation action that occurred """
        message = f"The RDS snapshot {self.snapshot_id} was shared with the public."
        if self.should_remediate():
            message += " Snapshot has been made private again."
        return message


def lambda_handler(event, _):
    """ Handles the incoming event """
    print(event)
    event_payload = json.loads(event["Records"][0]["body"])
    if subscription_confirmation.is_subscription_confirmation(event_payload):
        subscription_confirmation.confirm_subscription(event_payload)
        return
    rule = RDSPublicSnapshot(event_payload)
    rule.run_compliance_rule()
