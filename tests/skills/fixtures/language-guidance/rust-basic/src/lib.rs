pub trait Processor {
    type Error;

    fn process(&self, input: &str) -> Result<String, Self::Error>;
}

pub fn process_all<P: Processor>(processor: &P, inputs: &[&str]) -> Result<Vec<String>, P::Error> {
    inputs
        .iter()
        .map(|input| processor.process(input))
        .collect()
}
