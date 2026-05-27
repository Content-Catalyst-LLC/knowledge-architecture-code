package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"path/filepath"
)

func readCSV(path string) [][]string {
	f, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	r := csv.NewReader(f)
	rows, err := r.ReadAll()
	if err != nil {
		log.Fatal(err)
	}
	return rows
}

func main() {
	root := filepath.Join("..")
	conceptRows := readCSV(filepath.Join(root, "data", "concepts.csv"))
	relationshipRows := readCSV(filepath.Join(root, "data", "relationships.csv"))

	concepts := map[string]bool{}
	for i, row := range conceptRows {
		if i == 0 || len(row) == 0 {
			continue
		}
		concepts[row[0]] = true
	}

	issues := 0
	for i, row := range relationshipRows {
		if i == 0 || len(row) < 2 {
			continue
		}
		if !concepts[row[0]] {
			fmt.Printf("Missing source concept: %s\n", row[0])
			issues++
		}
		if !concepts[row[1]] {
			fmt.Printf("Missing target concept: %s\n", row[1])
			issues++
		}
	}

	if issues > 0 {
		log.Fatalf("Map integrity check failed with %d issue(s).", issues)
	}
	fmt.Println("Map integrity check passed.")
}
