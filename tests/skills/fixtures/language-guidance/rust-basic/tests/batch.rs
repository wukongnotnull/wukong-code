use rust_language_guidance_fixture::{process_all, Processor};

struct StubProcessor;

impl Processor for StubProcessor {
    type Error = String;

    fn process(&self, input: &str) -> Result<String, Self::Error> {
        match input.strip_prefix("fail:") {
            Some(message) => Err(message.to_owned()),
            None => Ok(input.to_uppercase()),
        }
    }
}

#[test]
fn process_all_preserves_input_order() {
    let result = process_all(&StubProcessor, &["first", "second", "third"]);

    assert_eq!(
        result,
        Ok(vec![
            "FIRST".to_owned(),
            "SECOND".to_owned(),
            "THIRD".to_owned(),
        ])
    );
}

#[test]
fn process_all_returns_the_lowest_input_index_error() {
    let result = process_all(
        &StubProcessor,
        &["ok", "fail:lowest-index", "fail:later-index"],
    );

    assert_eq!(result, Err("lowest-index".to_owned()));
}
