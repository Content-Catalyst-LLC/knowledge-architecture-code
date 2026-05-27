use std::fs;
use std::path::Path;

fn main() {
    let path = Path::new("../data/taxonomy_terms.csv");
    let content = fs::read_to_string(path).expect("Unable to read taxonomy_terms.csv from ../data");
    let line_count = content.lines().count().saturating_sub(1);
    let missing_scope = content
        .lines()
        .skip(1)
        .filter(|line| line.split(',').nth(5).unwrap_or("").trim().is_empty())
        .count();

    println!("taxonomy_terms={}", line_count);
    println!("missing_scope_notes={}", missing_scope);

    if missing_scope > 0 {
        std::process::exit(1);
    }
}
