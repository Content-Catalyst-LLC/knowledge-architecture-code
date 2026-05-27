package main

import "fmt"

func main() {
	concepts := 8.0
	crosswalks := 6.0

	fmt.Printf("Scope note coverage: %.3f\n", 7.0/concepts)
	fmt.Printf("Method context coverage: %.3f\n", 7.0/concepts)
	fmt.Printf("Relationship traceability: %.3f\n", 5.0/crosswalks)
	fmt.Printf("False equivalence risk: %.3f\n", 1.0/crosswalks)
}
