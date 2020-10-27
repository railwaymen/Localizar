import Vapor
import Fluent

struct TranslationForm {
    static func getPage(from page: Page<TranslationModel>) throws -> PageOutput {
        PageOutput(
            total: page.metadata.total,
            items: try page.items.map {
                try TranslationForm(model: $0).getOutput()
            })
    }
    
    // MARK: - Instance
    var id: UUID?
    var key: String
    var value: String
    var localeID: String?
    var projectSlug: String
    
    // MARK: - Initialization
    init() {
        self.id = nil
        self.key = ""
        self.value = ""
        self.localeID = Locale.default.id
        self.projectSlug = ""
    }
    
    init(req: Request) throws {
        let input = try req.content.decode(Input.self)
        self.key = input.key
        self.value = input.value
        self.localeID = input.locale
        self.projectSlug = try req.parameters.require(ProjectModel.slugParameter)
    }
    
    init(model: TranslationModel) throws {
        self.id = try model.requireID()
        self.key = model.key
        self.value = model.value
        self.localeID = model.localeID
        self.projectSlug = model.project.slug
    }
    
    // MARK: - Internal
    func createModel(req: Request) -> EventLoopFuture<TranslationModel> {
        do {
            let userID = try req.auth.require(UserModel.self).requireID()
            return validate(on: req.db)
                .flatMap {
                    ProjectModel.query(on: req.db)
                        .filter(\.$slug == projectSlug)
                        .first()
                        .unwrap(or: Abort(.notFound))
                        .flatMapThrowing { (try $0.requireID(), $0.mainLocaleID) }
                }
                .flatMap { projectID, mainLocaleID in
                    let model = TranslationModel(
                        key: key,
                        value: value,
                        localeID: localeID ?? mainLocaleID,
                        createdBy: userID,
                        lastUpdateBy: userID,
                        projectID: projectID)
                    return model.create(on: req.db)
                        .map { model }
                }
        } catch {
            return req.eventLoop.future(error: error)
        }
    }
    
    func getOutput() -> Output {
        Output(
            id: id!,
            key: key,
            value: value)
    }
    
    func validate(on database: Database) -> EventLoopFuture<Void> {
        getLocaleID(on: database)
            .flatMapThrowing { localeID in
                if localeID.isEmpty || !Locale.all.contains(id: localeID) {
                    throw ValidationError.localeInvalid
                }
                return localeID
            }
            .flatMap { localeID in
                TranslationModel.query(on: database)
                    .filter(\.$localeID, .equal, localeID)
                    .filter(\.$key == key)
                    .first()
                    .guard({ $0 == nil }, else: ValidationError.keyExists)
            }
            .map { _ in Void() }
    }
}

// MARK: - Private
extension TranslationForm {
    private func getLocaleID(on database: Database) -> EventLoopFuture<String> {
        if let locale = localeID {
            return database.eventLoop.future(locale)
        } else {
            return ProjectModel.query(on: database)
                .filter(\.$slug == projectSlug)
                .first()
                .unwrap(or: Abort(.notFound))
                .map { $0.mainLocaleID }
        }
    }
    
    private func firstValidationError() -> ValidationError? {
        guard !key.isEmpty else { return .keyEmpty }
        guard !value.isEmpty else { return .valueEmpty }
        return nil
    }
}

// MARK: - Structures

extension TranslationForm {
    
    // MARK: PageOutput
    struct PageOutput: Encodable {
        let total: Int
        let items: [Output]
    }
    
    // MARK: - Output
    struct Output: Encodable {
        let id: UUID
        let key: String
        let value: String
    }
    
    enum ValidationError: CustomValidationError {
        case keyExists
        case keyEmpty
        case valueEmpty
        case localeInvalid
        
        var key: String {
            switch self {
            case .keyExists:
                return "keyExists"
            case .keyEmpty:
                return "keyEmpty"
            case .valueEmpty:
                return "valueEmpty"
            case .localeInvalid:
                return "localeInvalid"
            }
        }
    }
    
    // MARK: - Input
    private struct Input: Decodable {
        let key: String
        let value: String
        let locale: String?
    }
}
