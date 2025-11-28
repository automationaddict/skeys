// Copyright (c) 2025 John Nelson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

package main

import (
	"flag"
	"fmt"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/johnnelson/skeys-core/logging"
	"github.com/johnnelson/skeys-daemon/internal/server"
)

var (
	version = "0.0.1"
	commit  = "unknown"
)

func main() {
	socketPath := flag.String("socket", "/tmp/skeys.sock", "Unix socket path for gRPC server")
	showVersion := flag.Bool("version", false, "Show version information")
	logLevel := flag.String("log-level", "info", "Log level (debug, info, warn, error)")
	logPretty := flag.Bool("log-pretty", false, "Enable pretty (human-readable) logging")
	flag.Parse()

	if *showVersion {
		fmt.Printf("skeys-daemon %s (commit: %s)\n", version, commit)
		os.Exit(0)
	}

	// Initialize logger
	log := logging.New(logging.Config{
		Level:     *logLevel,
		Output:    os.Stderr,
		Pretty:    *logPretty,
		Component: "skeys-daemon",
	})

	log.InfoWithFields("skeys-daemon starting", map[string]interface{}{
		"version": version,
		"commit":  commit,
	})

	// Create the gRPC server
	srv, err := server.New(server.WithLogger(log), server.WithVersion(version, commit))
	if err != nil {
		log.FatalErr(err, "failed to create server")
	}

	// Remove existing socket file if it exists
	if err := os.RemoveAll(*socketPath); err != nil {
		log.FatalErr(err, "failed to remove existing socket")
	}

	// Create Unix socket listener
	listener, err := net.Listen("unix", *socketPath)
	if err != nil {
		log.ErrWithFields(err, "failed to listen on socket", map[string]interface{}{
			"socket_path": *socketPath,
		})
		log.Fatal("cannot start server")
	}
	defer listener.Close()

	// Set socket permissions (only owner can connect)
	if err := os.Chmod(*socketPath, 0600); err != nil {
		log.FatalErr(err, "failed to set socket permissions")
	}

	log.InfoWithFields("listening on Unix socket", map[string]interface{}{
		"socket_path": *socketPath,
	})

	// Handle shutdown signals
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	// Start server in a goroutine
	errChan := make(chan error, 1)
	go func() {
		errChan <- srv.Serve(listener)
	}()

	// Wait for shutdown signal or server error
	select {
	case sig := <-sigChan:
		log.InfoWithFields("received shutdown signal", map[string]interface{}{
			"signal": sig.String(),
		})
		srv.Stop()
	case err := <-errChan:
		if err != nil {
			log.FatalErr(err, "server error")
		}
	}

	log.Info("skeys-daemon stopped")
}
