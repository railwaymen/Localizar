import Vapor
import Fluent

struct ModelsMigration_v1_0_4: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TranslationModel.schema)
            .id()
            .field(TranslationModel.FieldKeys.key, .string, .required)
            .field(TranslationModel.FieldKeys.value, .string, .required)
            .field(TranslationModel.FieldKeys.localeID, .string, .required)
            .field(TranslationModel.FieldKeys.createdAt, .datetime, .required)
            .field(TranslationModel.FieldKeys.updatedAt, .datetime, .required)
            .field(TranslationModel.FieldKeys.createdBy, .uuid, .required)
            .foreignKey(
                TranslationModel.FieldKeys.createdBy,
                references: UserModel.schema, .id,
                onDelete: .restrict,
                onUpdate: .cascade)
            .field(TranslationModel.FieldKeys.lastUpdateBy, .uuid, .required)
            .foreignKey(
                TranslationModel.FieldKeys.lastUpdateBy,
                references: UserModel.schema, .id,
                onDelete: .restrict,
                onUpdate: .cascade)
            .field(TranslationModel.FieldKeys.project, .uuid, .required)
            .foreignKey(
                TranslationModel.FieldKeys.project,
                references: ProjectModel.schema, .id,
                onDelete: .cascade,
                onUpdate: .cascade)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TranslationModel.schema)
            .delete()
    }
}
