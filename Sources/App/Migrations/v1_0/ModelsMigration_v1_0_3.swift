import Vapor
import Fluent

struct ModelsMigration_v1_0_3: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ProjectModel.schema)
            .field(
                ProjectModel.FieldKeys.mainLocaleID,
                .string,
                .required,
                .sql(.default(Locale.default.id)))
            .field(
                ProjectModel.FieldKeys.supportedLocales,
                .array(of: .string),
                .required,
                .sql(.default(#"{"\#(Locale.default.id)"}"#)))
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ProjectModel.schema)
            .deleteField(ProjectModel.FieldKeys.supportedLocales)
            .deleteField(ProjectModel.FieldKeys.mainLocaleID)
            .update()
    }
}
