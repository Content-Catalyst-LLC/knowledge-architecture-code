use std::fs;
use std::path::Path;

fn validate_csv_header(path: &str, required: &[&str]) -> Result<(), String> {
    let contents = fs::read_to_string(path).map_err(|e| format!("{}: {}", path, e))?;
    let header = contents
        .lines()
        .next()
        .ok_or_else(|| format!("{} is empty", path))?;
    let cols: Vec<&str> = header.split(',').collect();

    for col in required {
        if !cols.contains(col) {
            return Err(format!("{} missing required column: {}", path, col));
        }
    }
    Ok(())
}

fn main() {
    let concept_path = "../data/concepts.csv";
    let relationship_path = "../data/relationships.csv";

    if !Path::new(concept_path).exists() || !Path::new(relationship_path).exists() {
        eprintln!("Run this from the rust/ directory so ../data/*.csv is available.");
        std::process::exit(1);
    }

    let checks = [
        validate_csv_header(concept_path, &["concept_id", "label", "domain", "depth", "status"]),
        validate_csv_header(relationship_path, &["source", "target", "relationship", "weight"]),
    ];

    for check in checks {
        if let Err(message) = check {
            eprintln!("Validation failed: {}", message);
            std::process::exit(1);
        }
    }

    println!("Knowledge architecture CSV validation passed.");
}
