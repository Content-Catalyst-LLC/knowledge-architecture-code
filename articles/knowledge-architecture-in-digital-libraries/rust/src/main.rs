fn main() {
    let objects = 10;
    let metadata_coverage = 9.0 / 10.0;
    let subject_coverage = 5.0 / 10.0;
    let rights_coverage = 7.0 / 10.0;
    let preservation_coverage = 6.0 / 10.0;
    println!("Digital library objects: {}", objects);
    println!("Metadata coverage: {:.3}", metadata_coverage);
    println!("Subject coverage: {:.3}", subject_coverage);
    println!("Rights coverage: {:.3}", rights_coverage);
    println!("Preservation coverage: {:.3}", preservation_coverage);
}
