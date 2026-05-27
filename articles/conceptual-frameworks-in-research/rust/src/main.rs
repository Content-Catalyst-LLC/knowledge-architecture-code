use std::fs;
use std::path::Path;

fn count_data_rows(path: &str) -> Result<usize, std::io::Error> {
    let content = fs::read_to_string(path)?;
    let mut lines = content.lines();
    lines.next(); // header
    Ok(lines.filter(|line| !line.trim().is_empty()).count())
}

fn main() {
    let files = [
        "../data/framework_concepts.csv",
        "../data/framework_relationships.csv",
        "../data/evidence_sources.csv",
        "../data/concept_evidence.csv",
    ];

    println!("Conceptual Framework CSV Validation");

    for file in files {
        if !Path::new(file).exists() {
            eprintln!("Missing file: {}", file);
            std::process::exit(1);
        }

        match count_data_rows(file) {
            Ok(count) => println!("{}: {} data rows", file, count),
            Err(err) => {
                eprintln!("Could not read {}: {}", file, err);
                std::process::exit(1);
            }
        }
    }

    println!("Validation completed.");
}
