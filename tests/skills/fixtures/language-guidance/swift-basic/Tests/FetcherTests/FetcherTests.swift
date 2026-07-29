import XCTest
@testable import Fetcher

private enum StubError: Error, Equatable {
    case failed
}

private struct StubClient: Client {
    func fetch(_ path: String) async throws -> String {
        throw StubError.failed
    }
}

final class FetcherTests: XCTestCase {
    func testFetchAllPropagatesClientError() async {
        do {
            _ = try await fetchAll(client: StubClient(), paths: ["/one"])
            XCTFail("Expected fetchAll to throw")
        } catch {
            XCTAssertEqual(error as? StubError, .failed)
        }
    }
}
