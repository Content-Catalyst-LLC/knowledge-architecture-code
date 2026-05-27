package main

import (
	"encoding/csv"
	"fmt"
	"os"
)

func main() {
	file, err := os.Open("../data/model_relationships.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}

	if len(records) <= 1 {
		fmt.Println("No relationship records found.")
		os.Exit(1)
	}

	fmt.Printf("Relationship records: %d\n", len(records)-1)
	fmt.Println("Basic Go relationship audit passed.")
}
