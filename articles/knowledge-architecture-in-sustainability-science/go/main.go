package main

import "fmt"

func main() {
	objects := 10.0
	relationships := 11.0

	fmt.Printf("Metadata coverage: %.3f\n", 9.0/objects)
	fmt.Printf("Justice context coverage: %.3f\n", 6.0/objects)
	fmt.Printf("Uncertainty context coverage: %.3f\n", 8.0/objects)
	fmt.Printf("Relationship traceability: %.3f\n", 10.0/relationships)
	fmt.Printf("Underspecified relationship risk: %.3f\n", 1.0/relationships)
}
