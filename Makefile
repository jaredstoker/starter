.PHONY: build deploy zip
build:
	docker build -t revops-routing:local ./services/routing
zip:
	zip -r revops-starter.zip .
