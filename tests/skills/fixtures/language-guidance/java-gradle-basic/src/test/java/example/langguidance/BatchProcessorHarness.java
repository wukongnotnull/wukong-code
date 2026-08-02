package example.langguidance;

import java.util.List;

public final class BatchProcessorHarness {
    public static void main(String[] args) {
        List<String> processed = new BatchProcessor().process(List.of("first", "second"));
        if (!processed.equals(List.of("first", "second"))) {
            throw new AssertionError("processing must preserve order");
        }
    }
}
