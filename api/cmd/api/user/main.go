package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	runtime "github.com/aws/aws-lambda-go/lambda"
)

func init() {
	fmt.Println("Initializing")
}

func main() {
	runtime.Start(handleRequest)
}

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	userName := resolveUser(request.RequestContext.Identity.User)
	return events.APIGatewayProxyResponse{StatusCode: 200, Body: userName}, nil
}

func resolveUser(requestUser string) string {
	if requestUser == "" {
		return "I dont know who you are"
	}

	return requestUser
}
