package example.langguidance;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public final class BatchProcessorTest {
    public static void main(String[] args) {
        var processor = new BatchProcessor();
        var actual = processor.processAll(List.of("first", "second"));

        if (!actual.equals(List.of("FIRST", "SECOND"))) {
            throw new AssertionError("processAll must preserve processed result order");
        }

        var controlled = processor.processAll(
            List.of("first", "second"),
            String::toUpperCase
        );
        if (!controlled.equals(List.of("FIRST", "SECOND"))) {
            throw new AssertionError("processAll must preserve controlled processor order");
        }

        try {
            processor.processAll(
                List.of("ok", "fail:lowest-index", "fail:later-index"),
                input -> {
                    if (input.startsWith("fail:")) {
                        throw new IllegalArgumentException(input.substring("fail:".length()));
                    }
                    return input.toUpperCase();
                }
            );
            throw new AssertionError("processAll must report the first failing input");
        } catch (IllegalArgumentException expected) {
            if (!expected.getMessage().equals("lowest-index")) {
                throw new AssertionError("processAll must report the lowest failing input index");
            }
        }

        var laterFailureCompleted = new CountDownLatch(1);
        try {
            processor.processAll(
                List.of("fail:lowest-index", "fail:later-index"),
                input -> {
                    if (input.equals("fail:lowest-index")) {
                        try {
                            if (!laterFailureCompleted.await(2, TimeUnit.SECONDS)) {
                                throw new AssertionError("processAll must start inputs concurrently");
                            }
                        } catch (InterruptedException interrupted) {
                            Thread.currentThread().interrupt();
                            throw new AssertionError("test coordination was interrupted", interrupted);
                        }
                        throw new IllegalArgumentException("lowest-index");
                    }
                    laterFailureCompleted.countDown();
                    throw new IllegalArgumentException("later-index");
                }
            );
            throw new AssertionError("processAll must report the lowest failure after all work completes");
        } catch (IllegalArgumentException expected) {
            if (!expected.getMessage().equals("lowest-index")) {
                throw new AssertionError("processAll must select the lowest index, not first completion");
            }
        }

        assertWorkerCapacityIsBounded(processor);
        assertInterruptedCallerWaitsForStartedWork(processor);
    }

    private static void assertWorkerCapacityIsBounded(BatchProcessor processor) {
        var firstTwoStarted = new CountDownLatch(2);
        var thirdStarted = new CountDownLatch(1);
        var releaseWorkers = new CountDownLatch(1);
        var startedWorkers = new AtomicInteger();
        var outcome = new AtomicReference<Throwable>();
        var caller = new Thread(() -> {
            try {
                processor.processAll(List.of("one", "two", "three"), input -> {
                    if (startedWorkers.incrementAndGet() <= 2) {
                        firstTwoStarted.countDown();
                    } else {
                        thirdStarted.countDown();
                    }
                    try {
                        releaseWorkers.await();
                    } catch (InterruptedException interrupted) {
                        Thread.currentThread().interrupt();
                        throw new AssertionError("worker was interrupted", interrupted);
                    }
                    return input;
                });
            } catch (Throwable failure) {
                outcome.set(failure);
            }
        });
        caller.start();
        await(firstTwoStarted, "processAll must start the bounded worker capacity");
        if (await(thirdStarted, 200)) {
            releaseWorkers.countDown();
            join(caller, "bounded worker test must finish");
            throw new AssertionError("processAll must not create one worker per input");
        }
        releaseWorkers.countDown();
        join(caller, "bounded worker test must finish");
        if (outcome.get() != null) {
            throw new AssertionError("bounded worker test failed", outcome.get());
        }
    }

    private static void assertInterruptedCallerWaitsForStartedWork(BatchProcessor processor) {
        var workStarted = new CountDownLatch(1);
        var workInterrupted = new CountDownLatch(1);
        var releaseWorker = new CountDownLatch(1);
        var outcome = new AtomicReference<Throwable>();
        var caller = new Thread(() -> {
            try {
                processor.processAll(List.of("slow"), input -> {
                    workStarted.countDown();
                    try {
                        new CountDownLatch(1).await();
                    } catch (InterruptedException interrupted) {
                        workInterrupted.countDown();
                        try {
                            releaseWorker.await();
                        } catch (InterruptedException repeated) {
                            Thread.currentThread().interrupt();
                            throw new AssertionError("cleanup worker was interrupted", repeated);
                        }
                    }
                    return input;
                });
            } catch (Throwable failure) {
                outcome.set(failure);
            }
        });
        caller.start();
        await(workStarted, "processAll must start the worker before interruption");
        caller.interrupt();
        await(workInterrupted, "interruption must reach the started worker");
        if (!caller.isAlive()) {
            releaseWorker.countDown();
            throw new AssertionError("processAll must wait for started work during cleanup");
        }
        releaseWorker.countDown();
        join(caller, "interrupted caller must finish after worker cleanup");
        if (!(outcome.get() instanceof IllegalStateException)) {
            throw new AssertionError("interrupted caller must report interruption", outcome.get());
        }
    }

    private static void await(CountDownLatch latch, String message) {
        if (!await(latch, 2)) {
            throw new AssertionError(message);
        }
    }

    private static boolean await(CountDownLatch latch, long timeoutMillis) {
        try {
            return latch.await(timeoutMillis, TimeUnit.MILLISECONDS);
        } catch (InterruptedException interrupted) {
            Thread.currentThread().interrupt();
            throw new AssertionError("test coordination was interrupted", interrupted);
        }
    }

    private static void join(Thread thread, String message) {
        try {
            thread.join(2_000);
        } catch (InterruptedException interrupted) {
            Thread.currentThread().interrupt();
            throw new AssertionError("test coordination was interrupted", interrupted);
        }
        if (thread.isAlive()) {
            throw new AssertionError(message);
        }
    }
}
