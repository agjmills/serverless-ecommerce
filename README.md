# Serverless eCommerce
An example of an ecommerce application utilising serverless components of AWS

Vaguely inspired by Laravel

Utilising the Serverless framework
## API

### HTTP Routing

Take a look at `./api/serverless.yml`, you can add a new route by copying the syntax of `functions.adminCategoryCreate`. 

The handler is a typical python module import path, to a specific function within the module, for this example function, 
the handler is located at `./api/http/handlers/administration/categories.py` inside the function `create()`

### Database Tables
Take a look at `./api/serverless.yml`, specifically the `resources.Resources` key. This defines a very simple table with one field.

### Validation
Validation is handled transparently for each of the HTTP handlers. Looking at `./api/http/handlers/administration/categories.py`, 
you can that the `create()` function has been decorate with `@http_event_validator(validator=CategoryCreateValidator)`

`http_event_validator` is a generic function that parses the JSON body of the request, and, if defined, passes the body 
to a validation class. The validation class should extend the abstract class `BaseValidator`, found within `./api/http/validators/base_validator.py`  

The `validate()` method of the Validator should validate the body received in the HTTP request, and add it to the `validated_body` dict, which gets returned by the `validated()` method.

### Database Models
Database models are python representations of database tables, and can be found in `./api/models`. Each model should extend the `Model` class, which is found in `./api/models/model.py`.

The only _real_ configuration that a Model has, is it's DynamoDB table name, inside the `table` property of each class. See `./api/models/category.py` for an example. 