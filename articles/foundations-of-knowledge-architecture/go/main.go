package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"path/filepath"
	"sort"
)

func mustReadCSV(path string) [][]string {
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
	return rows
}

func main() {
	root := ".."
	relationships := mustReadCSV(filepath.Join(root, "data", "relationships.csv"))
	degree := map[string]int{}

	for i, row := range relationships {
		if i == 0 || len(row) < 2 {
			continue
		}
		degree[row[0]]++
		degree[row[1]]++
	}

	type pair struct {
		Concept string
		Degree  int
	}
	pairs := make([]pair, 0, len(degree))
	for concept, value := range degree {
		pairs = append(pairs, pair{concept, value})
	}
	sort.Slice(pairs, func(i, j int) bool { return pairs[i].Degree > pairs[j].Degree })

	fmt.Println("Concept degree summary")
	for _, p := range pairs {
		fmt.Printf("%s,%d\n", p.Concept, p.Degree)
	}
}
