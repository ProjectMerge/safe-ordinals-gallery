package grpcClient

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"ord_data/grpcModels"
	"ord_data/utils"
	"os"
	"time"
)

func DetectNSFW(tx *grpcModels.NSFWRequest) (*grpcModels.NSFWResponse, error) {
	address := os.Getenv("SERVER_HOST")
	if address == "" {
		address = "0.0.0.0:4000"
	}
	utils.ReportMessage(fmt.Sprintf("gRPC Client connecting to %s", address))

	ctx, cancel := context.WithTimeout(context.Background(), 100*time.Second)
	grpcCon, err := grpc.DialContext(ctx, address, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		//utils.WrapErrorLog(fmt.Sprintf("did not connect: %s", err))
		cancel()
		return nil, err
	}
	defer grpcCon.Close()
	defer cancel()

	c := grpcModels.NewNSFWClient(grpcCon)
	return c.Detect(ctx, tx)
}
