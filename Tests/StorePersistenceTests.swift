import XCTest

final class StorePersistenceTests: XCTestCase {
    private func makeFileURL() throws -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false)
        addTeardownBlock { try FileManager.default.removeItem(at: directory) }
        return directory.appendingPathComponent("ainotetaker.json")
    }

    func testMissingFileSeedsThenLoadsSavedEdits() throws {
        let url = try makeFileURL()
        let store = Store(fileURL: url)
        XCTAssertNil(store.loadError)
        XCTAssertNotNil(store.list("inbox"))
        store.addList("Test list")
        let reopened = Store(fileURL: url)
        XCTAssertNil(reopened.loadError)
        XCTAssertEqual(reopened.lists, store.lists)
    }

    func testDamagedFileIsPreservedUntilRetryLoadsRestoredData() throws {
        let url = try makeFileURL()
        let original = Store(fileURL: url)
        original.addList("Recovered list")
        let backup = try Data(contentsOf: url)
        let damaged = Data("invalid JSON".utf8)
        try damaged.write(to: url)

        let store = Store(fileURL: url)
        XCTAssertNotNil(store.loadError)
        XCTAssertTrue(store.lists.isEmpty)
        store.addList("Must not overwrite")
        XCTAssertEqual(try Data(contentsOf: url), damaged)

        try backup.write(to: url)
        store.load()
        XCTAssertNil(store.loadError)
        XCTAssertEqual(store.lists, original.lists)
        store.addList("After retry")
        XCTAssertEqual(Store(fileURL: url).lists, store.lists)
    }
}
