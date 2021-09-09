from abc import ABC, abstractmethod

class BaseResponse(ABC):
    def __init__(self, model):
        self.model = model

    @abstractmethod
    def response(self, event):
        pass
