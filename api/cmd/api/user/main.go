package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	runtime "github.com/aws/aws-lambda-go/lambda"
	"github.com/jrolstad/react-reference-app/internal/core"
	"github.com/jrolstad/react-reference-app/internal/models"
)

func init() {
	fmt.Println("Initializing")
}

func main() {
	runtime.Start(handleRequest)
}

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	userData := &models.User{
		Name:            request.RequestContext.Identity.User,
		IsAuthenticated: request.RequestContext.Identity.User != "",
	}
	jsonResult := core.MapToJson(userData)

	return events.APIGatewayProxyResponse{StatusCode: 200, Body: jsonResult}, nil
}
