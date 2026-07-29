public protocol Client {
    func fetch(_ path: String) async throws -> String
}

public func fetchAll(client: any Client, paths: [String]) async throws -> [String] {
    var results: [String] = []
    results.reserveCapacity(paths.count)

    for path in paths {
        results.append(try await client.fetch(path))
    }

    return results
}
