use std::collections::{HashMap, HashSet};

fn main() {
    let edges = vec![
        ("ka", "foundations"),
        ("ka", "semantic"),
        ("ka", "platforms"),
        ("semantic", "taxonomy"),
        ("semantic", "hierarchy"),
        ("semantic", "ontology"),
        ("semantic", "graphs"),
        ("platforms", "metadata"),
        ("platforms", "libraries"),
    ];

    let mut children: HashMap<&str, Vec<&str>> = HashMap::new();
    let mut all_nodes: HashSet<&str> = HashSet::new();
    let mut child_nodes: HashSet<&str> = HashSet::new();

    for (parent, child) in edges {
        children.entry(parent).or_default().push(child);
        all_nodes.insert(parent);
        all_nodes.insert(child);
        child_nodes.insert(child);
    }

    let roots: Vec<_> = all_nodes.difference(&child_nodes).collect();

    println!("Hierarchy validator scaffold");
    println!("Node count: {}", all_nodes.len());
    println!("Root count: {}", roots.len());
    println!("Roots: {:?}", roots);
    println!("Parent count: {}", children.len());
}
