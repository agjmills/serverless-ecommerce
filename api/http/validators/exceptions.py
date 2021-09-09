class ValidationException(Exception):
    def __init__(self, expression, message):
        self.expression = expression
        self.message = message
        super().__init__(self.message)
