package main

import "fmt"

func main() {
	objects := 12.0
	relationships := 14.0

	fmt.Println("Systems-oriented knowledge architecture metrics")
	fmt.Printf("Metadata coverage: %.3f\n", 11.0/objects)
	fmt.Printf("Feedback role coverage: %.3f\n", 8.0/objects)
	fmt.Printf("Relationship traceability: %.3f\n", 13.0/relationships)
	fmt.Printf("Feedback edge share: %.3f\n", 6.0/relationships)
	fmt.Printf("Underspecified relationship risk: %.3f\n", 1.0/relationships)
}
