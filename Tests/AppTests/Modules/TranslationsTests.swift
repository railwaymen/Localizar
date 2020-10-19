import XCTVapor
import Fluent
@testable import App

extension XCTVaporTests {
    open override class func setUp() {
        super.setUp()
        XCTVapor.app = { () throws -> Application in
            let app = Application(.testing)
            try configure(app)
            try app.autoRevert().wait()
            try app.autoMigrate().wait()
            return app
        }
    }
}

final class TranslationsTests: XCTVaporTests {
    
    func testGetFirstPage() throws {
        // Arrange
        try initDatabase(app.db)
        let pageOptions = ["page": 1, "perPage": 5]
        // Act
        try app.testable().test(
            .GET,
            "v1/projects/slug/translations",
            beforeRequest: { req in
                try authenticate(&req, database: app.db)
                try req.query.encode(pageOptions)
            },
            afterResponse: { response in
                // Assert
                XCTAssertEqual(response.status, .ok)
                let object = try response.content.decode(PageResponse.self)
                XCTAssertEqual(object.items.count, 5)
                XCTAssertEqual(object.total, 10)
            })
    }
}

// MARK: - Private
extension TranslationsTests {
    private func initDatabase(_ database: Database) throws {
        let project = ProjectModel(name: "Name", slug: "slug", mainLocaleID: "en", supportedLocalesIDs: ["en"])
        try project.create(on: database).wait()
        let projectID = try project.requireID()
        let admin = try adminUser(on: database)
        let translations = (0..<10).map {
            TranslationModel(
                key: "tran_\($0)",
                value: "Translation \($0)",
                localeID: "en",
                createdBy: admin.id!,
                lastUpdateBy: admin.id!,
                projectID: projectID)
        }
        try project.$users.attach(admin, on: database).wait()
        try translations.create(on: database).wait()
    }
    
    private func authenticate(_ req: inout XCTHTTPRequest, database: Database) throws  {
        let admin = try adminUser(on: database)
        let token = UserTokenModel(token: UUID().uuidString, userID: admin.id!)
        try token.create(on: database).wait()
        req.headers.replaceOrAdd(name: "Token", value: token.token)
    }
    
    private func adminUser(on database: Database) throws -> UserModel {
        try UserModel.query(on: database)
            .filter(\.$username == "admin")
            .first()
            .unwrap(or: Abort(.internalServerError))
            .wait()
    }
}

// MARK: - Structures
private struct PageResponse: Decodable {
    let total: Int
    let items: [TranslationDecoder]
}

private struct TranslationDecoder: Decodable {
    let id: UUID
    let key: String
    let value: String
}
