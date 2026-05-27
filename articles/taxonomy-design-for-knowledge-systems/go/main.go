package main

import (
	"encoding/csv"
	"fmt"
	"os"
)

func main() {
	file, err := os.Open("../data/taxonomy_relationships.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}

	degree := map[string]int{}
	for i, row := range records {
		if i == 0 || len(row) < 3 {
			continue
		}
		degree[row[0]]++
		degree[row[1]]++
	}

	fmt.Println("Taxonomy relationship degree summary")
	for term, count := range degree {
		fmt.Printf("%s,%d\n", term, count)
	}
}
