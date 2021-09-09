import json
from json.decoder import JSONDecodeError
from typing import Callable, Dict, Type
from http.validators.exceptions import ValidationException
from http.validators.base_validator import BaseValidator

from aws_lambda_powertools.middleware_factory import lambda_handler_decorator

@lambda_handler_decorator
def http_event_validator(handler: Callable, event: Dict, context: Dict = None, validator: Type[BaseValidator] = None):
    body = None
    if "body" in event:
        try:
            body = json.loads(event["body"])
        except JSONDecodeError:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Invalid JSON"})
            }

    if validator is not None:
        try:
            event_validator = validator(body)
            event_validator.validate()
            event["body"] = event_validator.validated()
        except ValidationException as exception:
            return {
                "statusCode": 405,
                "body": json.dumps({"error": exception.message})
            }

    return handler(event, context)
