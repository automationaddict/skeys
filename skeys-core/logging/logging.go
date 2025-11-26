// Package logging provides structured JSON logging for skeys-core.
package logging

import (
	"context"
	"io"
	"os"
	"time"

	"github.com/rs/zerolog"
)

// Logger wraps zerolog.Logger with convenience methods.
type Logger struct {
	zl zerolog.Logger
}

// Config holds logging configuration.
type Config struct {
	// Level is the minimum log level (debug, info, warn, error)
	Level string
	// Output is where logs are written (defaults to os.Stderr)
	Output io.Writer
	// Pretty enables human-readable console output instead of JSON
	Pretty bool
	// Component is the component name added to all log entries
	Component string
}

// DefaultConfig returns a default logging configuration.
func DefaultConfig() Config {
	return Config{
		Level:     "info",
		Output:    os.Stderr,
		Pretty:    false,
		Component: "skeys",
	}
}

// New creates a new Logger with the given configuration.
func New(cfg Config) *Logger {
	if cfg.Output == nil {
		cfg.Output = os.Stderr
	}

	level := parseLevel(cfg.Level)

	var zl zerolog.Logger
	if cfg.Pretty {
		zl = zerolog.New(zerolog.ConsoleWriter{
			Out:        cfg.Output,
			TimeFormat: time.RFC3339,
		}).Level(level).With().Timestamp().Str("component", cfg.Component).Logger()
	} else {
		zl = zerolog.New(cfg.Output).Level(level).With().Timestamp().Str("component", cfg.Component).Logger()
	}

	return &Logger{zl: zl}
}

// parseLevel converts a string level to zerolog.Level.
func parseLevel(level string) zerolog.Level {
	switch level {
	case "debug":
		return zerolog.DebugLevel
	case "info":
		return zerolog.InfoLevel
	case "warn":
		return zerolog.WarnLevel
	case "error":
		return zerolog.ErrorLevel
	default:
		return zerolog.InfoLevel
	}
}

// WithComponent returns a new logger with an additional component field.
func (l *Logger) WithComponent(component string) *Logger {
	return &Logger{zl: l.zl.With().Str("component", component).Logger()}
}

// WithField returns a new logger with an additional field.
func (l *Logger) WithField(key string, value interface{}) *Logger {
	return &Logger{zl: l.zl.With().Interface(key, value).Logger()}
}

// Debug logs a debug message.
func (l *Logger) Debug(msg string) {
	l.zl.Debug().Msg(msg)
}

// Debugf logs a formatted debug message.
func (l *Logger) Debugf(format string, args ...interface{}) {
	l.zl.Debug().Msgf(format, args...)
}

// DebugWithFields logs a debug message with additional fields.
func (l *Logger) DebugWithFields(msg string, fields map[string]interface{}) {
	event := l.zl.Debug()
	for k, v := range fields {
		event = event.Interface(k, v)
	}
	event.Msg(msg)
}

// Info logs an info message.
func (l *Logger) Info(msg string) {
	l.zl.Info().Msg(msg)
}

// Infof logs a formatted info message.
func (l *Logger) Infof(format string, args ...interface{}) {
	l.zl.Info().Msgf(format, args...)
}

// InfoWithFields logs an info message with additional fields.
func (l *Logger) InfoWithFields(msg string, fields map[string]interface{}) {
	event := l.zl.Info()
	for k, v := range fields {
		event = event.Interface(k, v)
	}
	event.Msg(msg)
}

// Warn logs a warning message.
func (l *Logger) Warn(msg string) {
	l.zl.Warn().Msg(msg)
}

// Warnf logs a formatted warning message.
func (l *Logger) Warnf(format string, args ...interface{}) {
	l.zl.Warn().Msgf(format, args...)
}

// WarnWithFields logs a warning message with additional fields.
func (l *Logger) WarnWithFields(msg string, fields map[string]interface{}) {
	event := l.zl.Warn()
	for k, v := range fields {
		event = event.Interface(k, v)
	}
	event.Msg(msg)
}

// Error logs an error message.
func (l *Logger) Error(msg string) {
	l.zl.Error().Msg(msg)
}

// Errorf logs a formatted error message.
func (l *Logger) Errorf(format string, args ...interface{}) {
	l.zl.Error().Msgf(format, args...)
}

// ErrorWithFields logs an error message with additional fields.
func (l *Logger) ErrorWithFields(msg string, fields map[string]interface{}) {
	event := l.zl.Error()
	for k, v := range fields {
		event = event.Interface(k, v)
	}
	event.Msg(msg)
}

// Err logs an error with its message.
func (l *Logger) Err(err error, msg string) {
	l.zl.Error().Err(err).Msg(msg)
}

// ErrWithFields logs an error with additional fields.
func (l *Logger) ErrWithFields(err error, msg string, fields map[string]interface{}) {
	event := l.zl.Error().Err(err)
	for k, v := range fields {
		event = event.Interface(k, v)
	}
	event.Msg(msg)
}

// Fatal logs a fatal message and exits.
func (l *Logger) Fatal(msg string) {
	l.zl.Fatal().Msg(msg)
}

// Fatalf logs a formatted fatal message and exits.
func (l *Logger) Fatalf(format string, args ...interface{}) {
	l.zl.Fatal().Msgf(format, args...)
}

// FatalErr logs a fatal error and exits.
func (l *Logger) FatalErr(err error, msg string) {
	l.zl.Fatal().Err(err).Msg(msg)
}

// Context key for logger
type ctxKey struct{}

// WithContext returns a new context with the logger attached.
func (l *Logger) WithContext(ctx context.Context) context.Context {
	return context.WithValue(ctx, ctxKey{}, l)
}

// FromContext retrieves the logger from context, or returns a default logger.
func FromContext(ctx context.Context) *Logger {
	if l, ok := ctx.Value(ctxKey{}).(*Logger); ok {
		return l
	}
	return New(DefaultConfig())
}

// Nop returns a no-op logger that discards all output.
func Nop() *Logger {
	return &Logger{zl: zerolog.Nop()}
}
