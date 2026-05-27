package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"sort"
)

func main() {
	file, err := os.Open("../data/relationships.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	rows, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}

	degree := map[string]int{}

	for i, row := range rows {
		if i == 0 {
			continue
		}
		if len(row) < 3 {
			continue
		}
		source := row[0]
		target := row[1]
		degree[source]++
		degree[target]++
	}

	keys := make([]string, 0, len(degree))
	for key := range degree {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	fmt.Println("concept,degree")
	for _, key := range keys {
		fmt.Printf("%s,%d\n", key, degree[key])
	}
}
