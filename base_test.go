package main

import (
	"os"
	"testing"

	"path/filepath"
)

// TestParseAllCircuits recursively parses all circuit files in the directory
func TestParseAllCircuits(t *testing.T) {
	baseDirs := []string{"iden3-circuits/circuits", "circomlib/circuits", "data", "passport-zk-circuits/circuits"}

	for _, baseDir := range baseDirs {
		err := filepath.Walk(baseDir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if !info.IsDir() && filepath.Ext(path) == ".circom" {
				t.Run(path, func(t *testing.T) {
					if err := ParseFile(path); err != nil {
						t.Errorf("Failed to parse %s: %v", path, err)
					}
				})
			}

			return nil
		})

		if err != nil {
			t.Fatalf("Error walking the path %s: %v", baseDir, err)
		}
	}
}
