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
    let objects = read_csv_lines(root.join("data/infrastructure_objects.csv").to_str().unwrap());
    let relationships = read_csv_lines(root.join("data/infrastructure_relationships.csv").to_str().unwrap());

    let mut degree: HashMap<String, usize> = HashMap::new();

    for rel in relationships.iter() {
        *degree.entry(rel[0].clone()).or_insert(0) += 1;
        *degree.entry(rel[2].clone()).or_insert(0) += 1;
    }

    let mut orphan_count = 0;
    let mut review_needed = 0;

    for obj in objects.iter() {
        let object_id = &obj[0];
        let has_metadata = obj[3].to_lowercase() == "true";
        let has_governance = obj[4].to_lowercase() == "true";
        let is_orphan = !degree.contains_key(object_id);

        if is_orphan {
            orphan_count += 1;
            println!("Orphan infrastructure object: {}", object_id);
        }

        if !has_metadata || !has_governance || is_orphan {
            review_needed += 1;
            println!("Needs review: {}", object_id);
        }
    }

    println!("Infrastructure objects: {}", objects.len());
    println!("Relationships: {}", relationships.len());
    println!("Orphans: {}", orphan_count);
    println!("Review needed: {}", review_needed);
}
