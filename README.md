# Reference Application
Reference application using current stacks to build a fully functional applicaiton on AWS PaaS components.

# Development Environment Setup
## How to Build
### Health API
From the root of the repository, run the following command

```shell
docker build . -f ./build/package/user_api.dockerfile -t referenceuserlambda:latest
```

## How to Run Tests
From the root of the repository, run the following command
```shell
go test ./...
```

## How to Run Locally
To run locally, the AWS sam tools need to be installed using homebrew
```shell
brew tap aws/tap
brew install aws-sam-cli
```
### Health API
From the cmd/api/user path run the following:

1. Build the Lambda Function
```shell
GOOS=linux go build -o bin/lambda
```

2. Run the built Lambda Function
```shell
sam local start-api
```

testing
