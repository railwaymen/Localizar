import Vapor
import Fluent

final class ProjectModel: Model {
    static let schema: String = "projects"
    static let slugParameter: String = "project_slug"
    
    @ID var id: UUID?
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.slug) var slug: String!
    @Field(key: FieldKeys.mainLocaleID) var mainLocaleID: String
    @Field(key: FieldKeys.supportedLocales) var supportedLocalesIDs: [String]
    
    @Children(for: \TranslationModel.$project) var translations: [TranslationModel]
    @Siblings(through: ProjectUserPivot.self, from: \.$project, to: \.$user)
    var users: [UserModel]
    
    // MARK: - Initialization
    init() {}
    
    init(
        id: UUID? = nil,
        name: String,
        slug: String,
        mainLocaleID: String,
        supportedLocalesIDs: [String]
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.mainLocaleID = mainLocaleID
        self.supportedLocalesIDs = supportedLocalesIDs.contains(mainLocaleID)
            ? supportedLocalesIDs
            : ([mainLocaleID] + supportedLocalesIDs)
    }
    
    // MARK: - Internal
    func getTranslations(for localeID: String, on database: Database) -> EventLoopFuture<[TranslationModel]> {
        $translations.query(on: database)
            .filter(\.$localeID == localeID)
            .all()
    }
}

// MARK: - Structures
extension ProjectModel {
    struct FieldKeys {
        static var name: FieldKey { "name" }
        static var slug: FieldKey { "slug" }
        static var mainLocaleID: FieldKey { "main_locale" }
        static var supportedLocales: FieldKey { "supported_locales" }
    }
}
