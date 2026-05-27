use std::collections::HashSet;
use std::fs;
use std::path::Path;

fn main() {
    let root = Path::new("..");
    let concepts_path = root.join("data/concepts.csv");
    let relationships_path = root.join("data/relationships.csv");

    let concepts = fs::read_to_string(&concepts_path)
        .expect("Unable to read data/concepts.csv");
    let relationships = fs::read_to_string(&relationships_path)
        .expect("Unable to read data/relationships.csv");

    let mut ids = HashSet::new();
    for (i, line) in concepts.lines().enumerate() {
        if i == 0 || line.trim().is_empty() { continue; }
        if let Some(id) = line.split(',').next() {
            ids.insert(id.trim().to_string());
        }
    }

    let mut missing = 0usize;
    for (i, line) in relationships.lines().enumerate() {
        if i == 0 || line.trim().is_empty() { continue; }
        let cols: Vec<&str> = line.split(',').collect();
        if cols.len() < 2 { continue; }
        let source = cols[0].trim();
        let target = cols[1].trim();
        if !ids.contains(source) {
            eprintln!("Missing source concept: {}", source);
            missing += 1;
        }
        if !ids.contains(target) {
            eprintln!("Missing target concept: {}", target);
            missing += 1;
        }
    }

    if missing == 0 {
        println!("Knowledge map validation passed.");
    } else {
        eprintln!("Knowledge map validation failed with {} issue(s).", missing);
        std::process::exit(1);
    }
}
