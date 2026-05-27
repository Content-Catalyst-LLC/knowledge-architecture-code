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
	nav := readCSV(filepath.Join(root, "data", "navigation_links.csv"))
	sem := readCSV(filepath.Join(root, "data", "semantic_relationships.csv"))

	navDegree := map[string]int{}
	semDegree := map[string]int{}

	for _, row := range nav {
		navDegree[row[0]]++
		navDegree[row[1]]++
	}

	for _, row := range sem {
		semDegree[row[0]]++
		semDegree[row[2]]++
	}

	fmt.Printf("Navigation-connected objects: %d\n", len(navDegree))
	fmt.Printf("Semantic-connected objects: %d\n", len(semDegree))

	for node, degree := range semDegree {
		if navDegree[node] == 0 {
			fmt.Printf("Semantically connected but weakly visible: %s (%d)\n", node, degree)
		}
	}
}
