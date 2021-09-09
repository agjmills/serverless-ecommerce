import json
from http.validators.administration.categories import CategoryCreateValidator
from http.validators.decorators import http_event_validator
from models.category import Category

@http_event_validator(validator=CategoryCreateValidator)
def create(event, context):
    return {
        "statusCode": 201,
        "body": json.dumps(Category(event["body"]).save())
    }
