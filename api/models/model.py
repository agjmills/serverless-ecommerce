import boto3
from datetime import datetime, timezone

class Model():
    fields = {}
    table = ''

    def __init__(self, data):
        self.fields = data

    def save(self):
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(self.table)
        timestamps = {
            "created_at": datetime.utcnow().replace(tzinfo=timezone.utc).isoformat(),
            "updated_at": datetime.utcnow().replace(tzinfo=timezone.utc).isoformat(),
            "deleted_at": None
        }

        model_data = self.fields | timestamps
        table.put_item(Item=model_data)
        return model_data
