build:
	npm ci
	poetry install

deploy:
	npm ci
	serverless deploy --stage ${STAGE}

test:
	poetry run pytest

lint:
	poetry run pylint --rcfile=../.pylintrc http/

run-local:
	serverless offline --printOutput --stage=local

destroy:
	serverless remove --stage ${STAGE}