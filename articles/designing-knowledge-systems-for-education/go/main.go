package main

import "fmt"

func main() {
	objects := 14.0
	relationships := 16.0

	fmt.Println("Educational knowledge-system metrics")
	fmt.Printf("Metadata coverage: %.3f\n", 13.0/objects)
	fmt.Printf("Accessibility context coverage: %.3f\n", 13.0/objects)
	fmt.Printf("Review context coverage: %.3f\n", 12.0/objects)
	fmt.Printf("Relationship traceability: %.3f\n", 15.0/relationships)
	fmt.Printf("Underspecified relationship risk: %.3f\n", 1.0/relationships)
}
