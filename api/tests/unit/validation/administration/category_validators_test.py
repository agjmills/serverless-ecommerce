from http.validators.administration.categories import CategoryCreateValidator
from http.validators.exceptions import ValidationException


def test_category_name_is_required():
    input = {}
    validator = CategoryCreateValidator(input)
    try:
        validator.validate()
    except ValidationException as exception:
        assert exception.message == "The name field is required"

def test_category_name_fails_when_shorter_than_three_chars():
    input_four_chars = {"name": "test"}
    input_three_chars = {"name": "tes"}
    input_two_chars = {"name": "te"}
    input_one_char = {"name": "t"}

    validator = CategoryCreateValidator(input_four_chars)
    validator.validate()

    validator = CategoryCreateValidator(input_three_chars)
    try:
        validator.validate()
    except ValidationException as exception:
        assert exception.message == "The name field must be longer than 3 characters"

    validator = CategoryCreateValidator(input_two_chars)
    try:
        validator.validate()
    except ValidationException as exception:
        assert exception.message == "The name field must be longer than 3 characters"

    validator = CategoryCreateValidator(input_one_char)
    try:
        validator.validate()
    except ValidationException as exception:
        assert exception.message == "The name field must be longer than 3 characters"




