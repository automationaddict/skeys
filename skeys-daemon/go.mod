module github.com/johnnelson/skeys-daemon

go 1.22.7

require (
	github.com/johnnelson/skeys-core v0.0.0
	github.com/stretchr/testify v1.11.1
	golang.org/x/crypto v0.28.0
	google.golang.org/grpc v1.68.0
	google.golang.org/protobuf v1.35.1
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/fsnotify/fsnotify v1.9.0 // indirect
	github.com/kr/fs v0.1.0 // indirect
	github.com/mattn/go-colorable v0.1.13 // indirect
	github.com/mattn/go-isatty v0.0.19 // indirect
	github.com/patrikkj/sshconf v0.0.0-20241216082456-6307d2fb6ac1 // indirect
	github.com/pkg/sftp v1.13.6 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/rs/zerolog v1.34.0 // indirect
	golang.org/x/net v0.29.0 // indirect
	golang.org/x/sys v0.26.0 // indirect
	golang.org/x/text v0.19.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20240903143218-8af14fe29dc1 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace github.com/johnnelson/skeys-core => ../skeys-core
