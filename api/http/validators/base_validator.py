from abc import ABC, abstractmethod
from typing import Dict, Optional


class BaseValidator(ABC):
    body = None
    validated_body = None

    def __init__(self, event_body: Optional[Dict] = None):
        self.body = event_body

    @abstractmethod
    def validate(self) -> None:
        pass

    def validated(self) -> Optional[Dict]:
        return self.validated_body
