package example.langguidance;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

public final class BatchProcessor {
    private static final int MAX_WORKERS = 2;

    @FunctionalInterface
    public interface ItemProcessor {
        String process(String input);
    }

    public List<String> processAll(List<String> inputs) {
        return processAll(inputs, BatchProcessor::processInput);
    }

    public List<String> processAll(List<String> inputs, ItemProcessor itemProcessor) {
        Objects.requireNonNull(inputs, "inputs");
        Objects.requireNonNull(itemProcessor, "itemProcessor");
        if (inputs.isEmpty()) {
            return List.of();
        }

        var executor = Executors.newFixedThreadPool(Math.min(inputs.size(), MAX_WORKERS));
        var interrupted = false;
        try {
            var tasks = new ArrayList<java.util.concurrent.Callable<String>>(inputs.size());
            for (String input : inputs) {
                tasks.add(() -> itemProcessor.process(input));
            }
            var futures = executor.invokeAll(tasks);
            var results = new ArrayList<String>(inputs.size());
            Throwable lowestIndexFailure = null;
            for (Future<String> future : futures) {
                try {
                    results.add(future.get());
                } catch (ExecutionException failed) {
                    if (lowestIndexFailure == null) {
                        lowestIndexFailure = failed.getCause();
                    }
                }
            }
            if (lowestIndexFailure != null) {
                throw rethrow(lowestIndexFailure);
            }
            return results;
        } catch (InterruptedException caught) {
            interrupted = true;
            throw new IllegalStateException("interrupted while processing inputs", caught);
        } finally {
            shutdown(executor, interrupted);
        }
    }

    private static String processInput(String input) {
        if (input.startsWith("fail:")) {
            throw new IllegalArgumentException(input.substring("fail:".length()));
        }
        return input.toUpperCase();
    }

    private static RuntimeException rethrow(Throwable failure) {
        if (failure instanceof RuntimeException runtime) {
            return runtime;
        }
        if (failure instanceof Error error) {
            throw error;
        }
        return new IllegalStateException("input processing failed", failure);
    }

    private static void shutdown(ExecutorService executor, boolean restoreInterruption) {
        executor.shutdown();
        var interrupted = restoreInterruption;
        while (!executor.isTerminated()) {
            try {
                if (executor.awaitTermination(2, TimeUnit.SECONDS)) {
                    break;
                }
                executor.shutdownNow();
            } catch (InterruptedException caught) {
                interrupted = true;
                executor.shutdownNow();
            }
        }
        if (interrupted) {
            Thread.currentThread().interrupt();
        }
    }
}
