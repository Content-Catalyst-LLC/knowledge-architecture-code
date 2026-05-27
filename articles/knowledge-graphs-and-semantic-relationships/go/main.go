package main

import (
	"encoding/csv"
	"fmt"
	"os"
)

func mustRead(path string) [][]string {
	file, err := os.Open(path)
	if err != nil {
		panic(err)
	}
	defer file.Close()
	rows, err := csv.NewReader(file).ReadAll()
	if err != nil {
		panic(err)
	}
	return rows
}

func main() {
	nodes := mustRead("../data/nodes.csv")
	edges := mustRead("../data/edges.csv")

	nodeIDs := map[string]bool{}
	for _, row := range nodes[1:] {
		if len(row) > 0 {
			nodeIDs[row[0]] = true
		}
	}

	missing := 0
	for _, row := range edges[1:] {
		if len(row) < 4 {
			missing++
			continue
		}
		if !nodeIDs[row[1]] {
			fmt.Println("Unknown source:", row[1])
			missing++
		}
		if !nodeIDs[row[3]] {
			fmt.Println("Unknown target:", row[3])
			missing++
		}
	}

	fmt.Printf("nodes=%d edges=%d warnings=%d\n", len(nodes)-1, len(edges)-1, missing)
}
