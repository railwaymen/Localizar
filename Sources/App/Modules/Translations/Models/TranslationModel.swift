import Vapor
import Fluent

final class TranslationModel: Model {
    static let schema: String = "translations"
    
    @ID var id: UUID?
    @Field(key: FieldKeys.key) var key: String
    @Field(key: FieldKeys.value) var value: String
    @Field(key: FieldKeys.localeID) var localeID: String
    @Parent(key: FieldKeys.project) var project: ProjectModel
    
    // MARK: - Initialization
    init() {}
    
    init(
        id: UUID? = nil,
        key: String,
        value: String,
        localeID: String,
        projectID: ProjectModel.IDValue
    ) {
        self.id = id
        self.key = key
        self.value = value
        self.localeID = localeID
        self.$project.id = projectID
    }
}

// MARK: - Structures
extension TranslationModel {
    struct FieldKeys {
        static var key: FieldKey { "key" }
        static var value: FieldKey { "value" }
        static var localeID: FieldKey { "locale_id" }
        static var project: FieldKey { "project_id" }
    }
}
