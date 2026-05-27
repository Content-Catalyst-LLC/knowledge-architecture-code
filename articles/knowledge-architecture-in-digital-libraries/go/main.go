package main

import "fmt"

func main() {
	objects := 10.0
	fmt.Printf("Metadata coverage: %.3f\n", 9.0/objects)
	fmt.Printf("Subject coverage: %.3f\n", 5.0/objects)
	fmt.Printf("Rights coverage: %.3f\n", 7.0/objects)
	fmt.Printf("Preservation coverage: %.3f\n", 6.0/objects)
}
