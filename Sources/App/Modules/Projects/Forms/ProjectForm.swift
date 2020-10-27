import Vapor
import Fluent

struct ProjectForm: InOutForm {
    var name: String
    var slug: String
    var mainLocaleID: String
    var supportedLocalesIDs: [String]
    
    // MARK: - Initialization
    init() {
        self.name = ""
        self.slug = ""
        self.mainLocaleID = Locale.default.id
        self.supportedLocalesIDs = [Locale.default.id]
    }
    
    init(req: Request) throws {
        let input = try req.content.decode(Input.self)
        let name = input.name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.name = name
        self.slug = req.parameters.get(ProjectModel.slugParameter)
            ?? input.slug
            ?? name.convertedToSlug()
            ?? ""
        self.mainLocaleID = input.mainLocaleID
        self.supportedLocalesIDs = input.supportedLocales.flatMap { $0.isEmpty ? nil : $0 }
            ?? [input.mainLocaleID]
    }
    
    init(model: ProjectModel) {
        self.name = model.name
        self.slug = model.slug
        self.mainLocaleID = model.mainLocaleID
        self.supportedLocalesIDs = model.supportedLocalesIDs
    }
    
    // MARK: - Internal
    func createModel() throws -> ProjectModel {
        guard !slug.isEmpty else { throw ValidationError.slugCouldNotBeGenerated }
        return ProjectModel(
            name: name,
            slug: slug,
            mainLocaleID: mainLocaleID,
            supportedLocalesIDs: supportedLocalesIDs)
    }
    
    func updateModel(_ model: ProjectModel) -> ProjectModel {
        model.name = name
        model.mainLocaleID = mainLocaleID
        model.supportedLocalesIDs = supportedLocalesIDs
        return model
    }
    
    func validate(on database: Database) -> EventLoopFuture<Void> {
        ProjectModel.query(on: database)
            .filter(\.$slug == slug)
            .first()
            .guard({ $0 == nil }, else: ValidationError.projectNameAlreadyExists)
            .flatMapThrowing { _ in
                guard let error = firstValidationError() else { return }
                throw error
            }
        
    }
    
    func getOutput() -> Output {
        Output(
            name: name,
            slug: slug,
            mainLocale: mainLocaleID,
            supportedLocales: supportedLocalesIDs)
    }
}

// MARK: - Private
extension ProjectForm {
    private func firstValidationError() -> ValidationError? {
        guard !name.isEmpty else { return .projectNameTooShort }
        guard !slug.isEmpty else { return .slugCouldNotBeGenerated }
        guard Locale.all.contains(ids: [mainLocaleID] + supportedLocalesIDs) else { return .localeNotSupported }
        return nil
    }
}

// MARK: - Structures

extension ProjectForm {
    
    // MARK: ValidationError
    enum ValidationError: CustomValidationError {
        case projectNameAlreadyExists
        case projectNameTooShort
        
        case slugCouldNotBeGenerated
        
        case localeNotSupported
        
        var key: String {
            switch self {
            case .projectNameAlreadyExists:
                return "projectNameAlreadyExists"
            case .projectNameTooShort:
                return "projectNameTooShort"
            case .slugCouldNotBeGenerated:
                return "slugCouldNotBeGenerated"
            case .localeNotSupported:
                return "localeNotSupported"
            }
        }
    }
    
    // MARK: Input
    private struct Input: Decodable {
        let name: String
        let slug: String?
        let mainLocaleID: String
        let supportedLocales: [String]?
    }
    
    // MARK: Output
    struct Output: Encodable {
        let name: String
        let slug: String
        let mainLocale: String
        let supportedLocales: [String]
    }
}
