use std::fs;

fn main() {
    let path = "../data/model_elements.csv";
    let data = fs::read_to_string(path).expect("unable to read model_elements.csv");
    let rows = data.lines().skip(1).count();
    println!("Framework element rows: {}", rows);

    if rows == 0 {
        eprintln!("No framework elements found.");
        std::process::exit(1);
    }

    println!("Basic Rust validation passed.");
}
