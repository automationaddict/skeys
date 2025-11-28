package update

import (
	"encoding/json"
	"os"
	"path/filepath"
)

const settingsFileName = "update-settings.json"

// LoadSettings loads update settings from the config directory.
func LoadSettings(configDir string) (Settings, error) {
	settingsPath := filepath.Join(configDir, settingsFileName)

	data, err := os.ReadFile(settingsPath)
	if err != nil {
		if os.IsNotExist(err) {
			return DefaultSettings(), nil
		}
		return Settings{}, err
	}

	var settings Settings
	if err := json.Unmarshal(data, &settings); err != nil {
		return DefaultSettings(), err
	}

	return settings, nil
}

// SaveSettings saves update settings to the config directory.
func SaveSettings(configDir string, settings Settings) error {
	if err := os.MkdirAll(configDir, 0700); err != nil {
		return err
	}

	settingsPath := filepath.Join(configDir, settingsFileName)

	data, err := json.MarshalIndent(settings, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(settingsPath, data, 0600)
}
