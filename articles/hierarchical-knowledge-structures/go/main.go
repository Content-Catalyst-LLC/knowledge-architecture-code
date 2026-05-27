package main

import "fmt"

type Edge struct {
	Parent string
	Child  string
}

func main() {
	edges := []Edge{
		{"ka", "foundations"},
		{"ka", "semantic"},
		{"ka", "platforms"},
		{"semantic", "taxonomy"},
		{"semantic", "hierarchy"},
		{"semantic", "ontology"},
		{"semantic", "graphs"},
		{"platforms", "metadata"},
		{"platforms", "libraries"},
	}

	nodes := map[string]bool{}
	children := map[string][]string{}
	childNodes := map[string]bool{}

	for _, edge := range edges {
		nodes[edge.Parent] = true
		nodes[edge.Child] = true
		children[edge.Parent] = append(children[edge.Parent], edge.Child)
		childNodes[edge.Child] = true
	}

	rootCount := 0
	for node := range nodes {
		if !childNodes[node] {
			rootCount++
		}
	}

	fmt.Println("Hierarchy pathway audit scaffold")
	fmt.Printf("Node count: %d\n", len(nodes))
	fmt.Printf("Root count: %d\n", rootCount)
	fmt.Printf("Parent count: %d\n", len(children))
}
