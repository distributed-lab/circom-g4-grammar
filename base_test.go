package main

import (
	"os"
	"testing"

	"path/filepath"
)

// TestParseAllCircuits recursively parses all circuit files in the directory
func TestParseAllCircuits(t *testing.T) {
	baseDir := "iden3-circuits/circuits"

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
