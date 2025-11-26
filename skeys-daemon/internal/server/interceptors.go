package server

import (
	"context"
	"time"

	"github.com/johnnelson/skeys-core/logging"
	"google.golang.org/grpc"
	"google.golang.org/grpc/status"
)

// newLoggingInterceptor creates a gRPC unary interceptor that logs all requests
func newLoggingInterceptor(log *logging.Logger) grpc.UnaryServerInterceptor {
	return func(
		ctx context.Context,
		req interface{},
		info *grpc.UnaryServerInfo,
		handler grpc.UnaryHandler,
	) (interface{}, error) {
		start := time.Now()

		resp, err := handler(ctx, req)

		duration := time.Since(start)
		fields := map[string]interface{}{
			"method":      info.FullMethod,
			"duration_ms": duration.Milliseconds(),
		}

		if err != nil {
			st, _ := status.FromError(err)
			fields["status"] = st.Code().String()
			fields["error"] = st.Message()
			log.WarnWithFields("gRPC request failed", fields)
		} else {
			fields["status"] = "OK"
			log.InfoWithFields("gRPC request", fields)
		}

		return resp, err
	}
}
