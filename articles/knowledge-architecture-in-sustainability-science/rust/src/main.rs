fn main() {
    let objects = 10.0;
    let relationships = 11.0;

    println!("Sustainability objects: {}", objects as i32);
    println!("Relationships: {}", relationships as i32);
    println!("Metadata coverage: {:.3}", 9.0 / objects);
    println!("Justice context coverage: {:.3}", 6.0 / objects);
    println!("Uncertainty context coverage: {:.3}", 8.0 / objects);
    println!("Relationship traceability: {:.3}", 10.0 / relationships);
    println!("Underspecified relationship risk: {:.3}", 1.0 / relationships);
}
