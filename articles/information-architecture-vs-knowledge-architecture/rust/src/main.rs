use std::collections::HashMap;
use std::fs;
use std::path::Path;

fn read_csv_lines(path: &str) -> Vec<Vec<String>> {
    let text = fs::read_to_string(path).expect("failed to read CSV");
    text.lines()
        .skip(1)
        .filter(|line| !line.trim().is_empty())
        .map(|line| line.split(',').map(|s| s.to_string()).collect())
        .collect()
}

fn main() {
    let root = Path::new("..");
    let nav_path = root.join("data/navigation_links.csv");
    let sem_path = root.join("data/semantic_relationships.csv");

    let navigation = read_csv_lines(nav_path.to_str().unwrap());
    let semantic = read_csv_lines(sem_path.to_str().unwrap());

    let mut nav_degree: HashMap<String, usize> = HashMap::new();
    let mut sem_degree: HashMap<String, usize> = HashMap::new();

    for row in navigation {
        *nav_degree.entry(row[0].clone()).or_insert(0) += 1;
        *nav_degree.entry(row[1].clone()).or_insert(0) += 1;
    }

    for row in semantic {
        *sem_degree.entry(row[0].clone()).or_insert(0) += 1;
        *sem_degree.entry(row[2].clone()).or_insert(0) += 1;
    }

    println!("IA nodes with navigation links: {}", nav_degree.len());
    println!("KA nodes with semantic relationships: {}", sem_degree.len());

    for (node, degree) in nav_degree.iter() {
        if !sem_degree.contains_key(node) {
            println!("Navigable but semantically thin: {} ({})", node, degree);
        }
    }
}
