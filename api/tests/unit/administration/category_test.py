from http.validators.administration.categories import CategoryCreateValidator
from http.validators.exceptions import ValidationException

def test_category_name_is_required():
    input = {}
    validator = CategoryCreateValidator(input)

    try:
        validator.validate()
    except ValidationException as exception:
        assert exception.message == "The name field is required"
