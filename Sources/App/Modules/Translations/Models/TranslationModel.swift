import Vapor
import Fluent

final class TranslationModel: Model {
    static let schema: String = "translations"
    
    @ID var id: UUID?
    @Field(key: FieldKeys.key) var key: String
    @Field(key: FieldKeys.value) var value: String
    @Field(key: FieldKeys.localeID) var localeID: String
    @Field(key: FieldKeys.createdAt) var createdAt: Date
    @Field(key: FieldKeys.updatedAt) var updatedAt: Date
    
    @Parent(key: FieldKeys.createdBy) var createdBy: UserModel
    @Parent(key: FieldKeys.lastUpdateBy) var lastUpdateBy: UserModel
    @Parent(key: FieldKeys.project) var project: ProjectModel
    
    // MARK: - Initialization
    init() {}
    
    init(
        id: IDValue? = nil,
        key: String,
        value: String,
        localeID: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        createdBy: UserModel.IDValue,
        lastUpdateBy: UserModel.IDValue,
        projectID: ProjectModel.IDValue
    ) {
        self.id = id
        self.key = key
        self.value = value
        self.localeID = localeID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.$createdBy.id = createdBy
        self.$lastUpdateBy.id = lastUpdateBy
        self.$project.id = projectID
    }
}

// MARK: - Structures
extension TranslationModel {
    struct FieldKeys {
        static var key: FieldKey { "key" }
        static var value: FieldKey { "value" }
        static var localeID: FieldKey { "locale_id" }
        static var createdAt: FieldKey { "created_at" }
        static var updatedAt: FieldKey { "updated_at" }
        static var createdBy: FieldKey { "created_by" }
        static var lastUpdateBy: FieldKey { "last_update_by" }
        static var project: FieldKey { "project_id" }
    }
}
