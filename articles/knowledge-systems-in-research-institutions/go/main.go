package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
)

func readCSV(path string) [][]string {
	file, err := os.Open(path)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	rows, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}
	if len(rows) <= 1 {
		return [][]string{}
	}
	return rows[1:]
}

func main() {
	root := filepath.Join("..")
	objects := readCSV(filepath.Join(root, "data", "research_objects.csv"))
	relationships := readCSV(filepath.Join(root, "data", "object_relationships.csv"))

	degree := map[string]int{}

	for _, row := range relationships {
		degree[row[0]]++
		degree[row[2]]++
	}

	orphanCount := 0
	metadataMissing := 0

	for _, row := range objects {
		objectID := row[0]
		if degree[objectID] == 0 {
			orphanCount++
			fmt.Printf("Orphan research object: %s\n", objectID)
		}
		if row[3] != "true" {
			metadataMissing++
			fmt.Printf("Missing metadata: %s\n", objectID)
		}
	}

	fmt.Printf("Research objects: %d\n", len(objects))
	fmt.Printf("Relationships: %d\n", len(relationships))
	fmt.Printf("Orphans: %d\n", orphanCount)
	fmt.Printf("Metadata missing: %d\n", metadataMissing)
}
