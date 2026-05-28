package main

import "fmt"

func main() {
	objects := 14.0
	relationships := 15.0

	fmt.Println("Governance knowledge-architecture metrics")
	fmt.Printf("Metadata coverage: %.3f\n", 13.0/objects)
	fmt.Printf("Accountability context coverage: %.3f\n", 11.0/objects)
	fmt.Printf("Equity context coverage: %.3f\n", 9.0/objects)
	fmt.Printf("Relationship traceability: %.3f\n", 14.0/relationships)
	fmt.Printf("Underspecified relationship risk: %.3f\n", 1.0/relationships)
}
