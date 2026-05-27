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
    let objects = read_csv_lines(root.join("data/research_objects.csv").to_str().unwrap());
    let relationships = read_csv_lines(root.join("data/object_relationships.csv").to_str().unwrap());

    let mut degree: HashMap<String, usize> = HashMap::new();

    for rel in relationships.iter() {
        *degree.entry(rel[0].clone()).or_insert(0) += 1;
        *degree.entry(rel[2].clone()).or_insert(0) += 1;
    }

    let mut orphan_count = 0;
    let mut metadata_missing = 0;

    for obj in objects.iter() {
        let object_id = &obj[0];
        if !degree.contains_key(object_id) {
            orphan_count += 1;
            println!("Orphan research object: {}", object_id);
        }
        if obj[3].to_lowercase() != "true" {
            metadata_missing += 1;
            println!("Missing metadata: {}", object_id);
        }
    }

    println!("Research objects: {}", objects.len());
    println!("Relationships: {}", relationships.len());
    println!("Orphans: {}", orphan_count);
    println!("Metadata missing: {}", metadata_missing);
}
