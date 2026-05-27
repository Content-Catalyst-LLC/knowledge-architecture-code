use std::collections::HashMap;
use std::fs;

fn main() {
    let path = "../data/relationships.csv";
    let contents = fs::read_to_string(path).expect("Could not read relationships.csv");

    let mut degree: HashMap<String, usize> = HashMap::new();

    for (i, line) in contents.lines().enumerate() {
        if i == 0 { continue; }

        let parts: Vec<&str> = line.split(',').collect();
        if parts.len() < 3 { continue; }

        let source = parts[0].trim().to_string();
        let target = parts[1].trim().to_string();

        *degree.entry(source).or_insert(0) += 1;
        *degree.entry(target).or_insert(0) += 1;
    }

    println!("Concept degree summary:");
    let mut rows: Vec<_> = degree.iter().collect();
    rows.sort_by(|a, b| a.0.cmp(b.0));

    for (concept, count) in rows {
        println!("{},{}", concept, count);
    }
}
