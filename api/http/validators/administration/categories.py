from http.validators.base_validator import BaseValidator
from http.validators.exceptions import ValidationException

class CategoryCreateValidator(BaseValidator):
    def validate(self) -> None:
        if self.body is None:
            raise ValidationException(self.body, 'No JSON body was provided')

        if "name" not in self.body:
            raise ValidationException(self.body, 'The name field is required')

        if len(self.body["name"]) <= 3:
            raise ValidationException(self.body, 'The name field must be longer than 3 characters')
