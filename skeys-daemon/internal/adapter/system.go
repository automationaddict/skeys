// Package adapter provides adapters between gRPC services and the core library.
package adapter

import (
	"context"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/johnnelson/skeys-core/system"
	pb "github.com/johnnelson/skeys-daemon/api/gen/skeys/v1"
)

// SystemServiceAdapter adapts the system services to the gRPC SystemService interface.
type SystemServiceAdapter struct {
	pb.UnimplementedSystemServiceServer
	systemMgr *system.SystemManager
}

// NewSystemServiceAdapter creates a new system service adapter.
func NewSystemServiceAdapter() *SystemServiceAdapter {
	return &SystemServiceAdapter{
		systemMgr: system.NewSystemManager(),
	}
}

// WatchSSHStatus streams SSH status updates when changes are detected.
func (a *SystemServiceAdapter) WatchSSHStatus(req *pb.WatchSSHStatusRequest, stream pb.SystemService_WatchSSHStatusServer) error {
	ctx := stream.Context()

	// Use the core service's Watch method which polls for status changes
	updates := a.systemMgr.Watch(ctx)

	for update := range updates {
		if update.Err != nil {
			return status.Errorf(codes.Internal, "watch error: %v", update.Err)
		}

		resp := &pb.GetSSHStatusResponse{
			Distribution:        update.Status.Distribution,
			DistributionVersion: update.Status.DistributionVersion,
			Client:              toProtoSSHClientStatus(&update.Status.Client),
			Server:              toProtoSSHServerStatus(&update.Status.Server),
		}

		if err := stream.Send(resp); err != nil {
			return err
		}
	}

	return nil
}

// GetSSHStatus returns comprehensive SSH system status.
func (a *SystemServiceAdapter) GetSSHStatus(ctx context.Context, req *pb.GetSSHStatusRequest) (*pb.GetSSHStatusResponse, error) {
	sshStatus, err := a.systemMgr.GetSSHStatus(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get SSH status: %v", err)
	}

	return &pb.GetSSHStatusResponse{
		Distribution:        sshStatus.Distribution,
		DistributionVersion: sshStatus.DistributionVersion,
		Client:              toProtoSSHClientStatus(&sshStatus.Client),
		Server:              toProtoSSHServerStatus(&sshStatus.Server),
	}, nil
}

// GetSSHServiceStatus returns the SSH server service status.
func (a *SystemServiceAdapter) GetSSHServiceStatus(ctx context.Context, req *pb.GetSSHServiceStatusRequest) (*pb.GetSSHServiceStatusResponse, error) {
	serviceStatus, err := a.systemMgr.GetSSHServiceStatus(ctx)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get SSH service status: %v", err)
	}

	return &pb.GetSSHServiceStatusResponse{
		Status: toProtoServiceStatus(serviceStatus),
	}, nil
}

// StartSSHService starts the SSH server service.
func (a *SystemServiceAdapter) StartSSHService(ctx context.Context, req *pb.StartSSHServiceRequest) (*pb.SSHServiceControlResponse, error) {
	serviceStatus, err := a.systemMgr.StartSSHService(ctx)
	if err != nil {
		return &pb.SSHServiceControlResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.SSHServiceControlResponse{
		Success: true,
		Message: "SSH service started successfully",
		Status:  toProtoServiceStatus(serviceStatus),
	}, nil
}

// StopSSHService stops the SSH server service.
func (a *SystemServiceAdapter) StopSSHService(ctx context.Context, req *pb.StopSSHServiceRequest) (*pb.SSHServiceControlResponse, error) {
	serviceStatus, err := a.systemMgr.StopSSHService(ctx)
	if err != nil {
		return &pb.SSHServiceControlResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.SSHServiceControlResponse{
		Success: true,
		Message: "SSH service stopped successfully",
		Status:  toProtoServiceStatus(serviceStatus),
	}, nil
}

// RestartSSHServiceWithStatus restarts the SSH server service.
func (a *SystemServiceAdapter) RestartSSHServiceWithStatus(ctx context.Context, req *pb.RestartSSHServiceWithStatusRequest) (*pb.SSHServiceControlResponse, error) {
	serviceStatus, err := a.systemMgr.RestartSSHService(ctx)
	if err != nil {
		return &pb.SSHServiceControlResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.SSHServiceControlResponse{
		Success: true,
		Message: "SSH service restarted successfully",
		Status:  toProtoServiceStatus(serviceStatus),
	}, nil
}

// ReloadSSHService reloads the SSH server service configuration.
func (a *SystemServiceAdapter) ReloadSSHService(ctx context.Context, req *pb.ReloadSSHServiceRequest) (*pb.SSHServiceControlResponse, error) {
	serviceStatus, err := a.systemMgr.ReloadSSHService(ctx)
	if err != nil {
		return &pb.SSHServiceControlResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.SSHServiceControlResponse{
		Success: true,
		Message: "SSH service configuration reloaded successfully",
		Status:  toProtoServiceStatus(serviceStatus),
	}, nil
}

// EnableSSHService enables the SSH server service to start on boot.
func (a *SystemServiceAdapter) EnableSSHService(ctx context.Context, req *pb.EnableSSHServiceRequest) (*pb.SSHServiceControlResponse, error) {
	serviceStatus, err := a.systemMgr.EnableSSHService(ctx)
	if err != nil {
		return &pb.SSHServiceControlResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.SSHServiceControlResponse{
		Success: true,
		Message: "SSH service enabled for auto-start",
		Status:  toProtoServiceStatus(serviceStatus),
	}, nil
}

// DisableSSHService disables the SSH server service from starting on boot.
func (a *SystemServiceAdapter) DisableSSHService(ctx context.Context, req *pb.DisableSSHServiceRequest) (*pb.SSHServiceControlResponse, error) {
	serviceStatus, err := a.systemMgr.DisableSSHService(ctx)
	if err != nil {
		return &pb.SSHServiceControlResponse{
			Success: false,
			Message: err.Error(),
		}, nil
	}

	return &pb.SSHServiceControlResponse{
		Success: true,
		Message: "SSH service disabled from auto-start",
		Status:  toProtoServiceStatus(serviceStatus),
	}, nil
}

// GetInstallInstructions returns installation instructions for a component.
func (a *SystemServiceAdapter) GetInstallInstructions(ctx context.Context, req *pb.GetInstallInstructionsRequest) (*pb.GetInstallInstructionsResponse, error) {
	component := "client"
	if req.GetComponent() == pb.SSHComponent_SSH_COMPONENT_SERVER {
		component = "server"
	}

	instructions := a.systemMgr.GetInstallInstructions(component)

	return &pb.GetInstallInstructionsResponse{
		Distribution:     instructions.Distribution,
		Component:        req.GetComponent(),
		PackageName:      instructions.PackageName,
		InstallCommand:   instructions.InstallCommand,
		DocumentationUrl: instructions.DocumentationURL,
		Steps:            instructions.Steps,
	}, nil
}

// ============================================================
// Conversion functions
// ============================================================

func toProtoSSHClientStatus(s *system.SSHClientStatus) *pb.SSHClientStatus {
	return &pb.SSHClientStatus{
		Installed:    s.Installed,
		Version:      s.Version,
		BinaryPath:   s.BinaryPath,
		SystemConfig: toProtoSystemConfigPathInfo(&s.SystemConfig),
		UserConfig:   toProtoSystemConfigPathInfo(&s.UserConfig),
	}
}

func toProtoSSHServerStatus(s *system.SSHServerStatus) *pb.SSHServerStatus {
	return &pb.SSHServerStatus{
		Installed:  s.Installed,
		Version:    s.Version,
		BinaryPath: s.BinaryPath,
		Service:    toProtoServiceStatus(&s.Service),
		Config:     toProtoSystemConfigPathInfo(&s.Config),
	}
}

func toProtoSystemConfigPathInfo(info *system.ConfigPathInfo) *pb.ConfigPathInfo {
	return &pb.ConfigPathInfo{
		Path:       info.Path,
		Exists:     info.Exists,
		Readable:   info.Readable,
		Writable:   info.Writable,
		IncludeDir: info.IncludeDir,
	}
}

func toProtoServiceStatus(s *system.ServiceStatus) *pb.ServiceStatus {
	var state pb.ServiceState
	switch s.State {
	case system.ServiceStateRunning:
		state = pb.ServiceState_SERVICE_STATE_RUNNING
	case system.ServiceStateStopped:
		state = pb.ServiceState_SERVICE_STATE_STOPPED
	case system.ServiceStateFailed:
		state = pb.ServiceState_SERVICE_STATE_FAILED
	case system.ServiceStateNotFound:
		state = pb.ServiceState_SERVICE_STATE_NOT_FOUND
	case system.ServiceStateUnknown:
		state = pb.ServiceState_SERVICE_STATE_UNKNOWN
	default:
		state = pb.ServiceState_SERVICE_STATE_UNSPECIFIED
	}

	startedAt := ""
	if !s.StartedAt.IsZero() {
		startedAt = s.StartedAt.Format("2006-01-02T15:04:05Z07:00")
	}

	return &pb.ServiceStatus{
		State:       state,
		Enabled:     s.Enabled,
		ActiveState: s.ActiveState,
		SubState:    s.SubState,
		LoadState:   s.LoadState,
		Pid:         s.PID,
		StartedAt:   startedAt,
		ServiceName: s.ServiceName,
	}
}
