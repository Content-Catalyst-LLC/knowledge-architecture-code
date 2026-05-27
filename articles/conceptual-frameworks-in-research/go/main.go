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
	records, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}

	return records
}

func main() {
	root := filepath.Join("..")
	concepts := readCSV(filepath.Join(root, "data", "framework_concepts.csv"))
	relationships := readCSV(filepath.Join(root, "data", "framework_relationships.csv"))

	relationshipTypes := map[string]int{}

	for i, row := range relationships {
		if i == 0 {
			continue
		}
		if len(row) >= 3 {
			relationshipTypes[row[2]]++
		}
	}

	fmt.Println("Conceptual Framework Summary")
	fmt.Printf("Concepts: %d\n", len(concepts)-1)
	fmt.Printf("Relationships: %d\n", len(relationships)-1)
	fmt.Println("Relationship types:")

	for relType, count := range relationshipTypes {
		fmt.Printf(" - %s: %d\n", relType, count)
	}
}
