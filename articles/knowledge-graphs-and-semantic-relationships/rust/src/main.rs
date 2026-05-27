use std::collections::HashSet;
use std::fs;
use std::path::Path;

fn read_ids(path: &str, column_index: usize) -> HashSet<String> {
    let content = fs::read_to_string(path).expect("failed to read file");
    content
        .lines()
        .skip(1)
        .filter_map(|line| line.split(',').nth(column_index).map(|s| s.trim().to_string()))
        .collect()
}

fn main() {
    let node_path = "data/nodes.csv";
    let edge_path = "data/edges.csv";

    if !Path::new(node_path).exists() || !Path::new(edge_path).exists() {
        eprintln!("Run this from the article folder containing data/nodes.csv and data/edges.csv");
        std::process::exit(1);
    }

    let node_ids = read_ids(node_path, 0);
    let edges = fs::read_to_string(edge_path).expect("failed to read edges");
    let mut warnings = 0;

    for line in edges.lines().skip(1) {
        let parts: Vec<&str> = line.split(',').collect();
        if parts.len() < 6 {
            warnings += 1;
            continue;
        }
        let source = parts[1].trim();
        let target = parts[3].trim();
        if !node_ids.contains(source) {
            println!("Unknown source node: {}", source);
            warnings += 1;
        }
        if !node_ids.contains(target) {
            println!("Unknown target node: {}", target);
            warnings += 1;
        }
    }

    println!("Validation complete. warnings={}", warnings);
}
