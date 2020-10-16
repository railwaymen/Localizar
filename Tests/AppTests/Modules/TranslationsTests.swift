import XCTVapor
import Fluent
@testable import App

extension XCTVaporTests {
    open override class func setUp() {
        super.setUp()
        XCTVapor.app = { () throws -> Application in
            let app = Application(.testing)
            try configure(app)
            try app.autoMigrate().wait()
            return app
        }
    }
}

final class TranslationsTests: XCTVaporTests {
    
    func testGetFirstPage() throws {
        // Arrange
        try initDatabase(app.db(.psql))
        // Act
        try app.testable().test(.GET, "/v1/translations", afterResponse: { response in
            // Assert
            XCTAssertEqual(response.status, .ok)
            let array = try response.content.decode([TranslationDecoder].self)
            XCTAssertEqual(array.count, 10)
        })
    }
    
    private func initDatabase(_ database: Database) throws {
        let project = ProjectModel(name: "Name", slug: "slug", mainLocaleID: "en", supportedLocalesIDs: ["en"])
        try project.create(on: database).wait()
        let projectID = try project.requireID()
        let translations = (0..<10).map {
            TranslationModel(
                key: "tran_\($0)",
                value: "Translation \($0)",
                localeID: "en",
                projectID: projectID)
        }
        try translations.create(on: database).wait()
    }
}

// MARK: - Structures
private struct TranslationDecoder: Decodable {
    let id: UUID
    let key: String
    let name: String
}
