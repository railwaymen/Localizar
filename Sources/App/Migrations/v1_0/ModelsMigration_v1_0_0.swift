import Vapor
import Fluent

struct ModelsMigration_v1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(UserModel.schema)
                .id()
                .field(UserModel.FieldKeys.username, .string, .required, .sql(.unique))
                .field(UserModel.FieldKeys.password, .string, .required)
                .create(),
            database.schema(UserTokenModel.schema)
                .id()
                .field(UserTokenModel.FieldKeys.token, .string, .required, .sql(.unique))
                .field(UserTokenModel.FieldKeys.createdAt, .datetime, .required)
                .field(UserTokenModel.FieldKeys.user, .uuid, .required)
                .foreignKey(UserTokenModel.FieldKeys.user, references: UserModel.schema, .id, onDelete: .cascade, onUpdate: .cascade)
                .create(),
            UserModel(
                username: "admin",
                password: try! Bcrypt.hash(Environment.get("ADMIN_PASSWORD")!))
                .save(on: database)
        ])
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(UserTokenModel.schema)
                .delete(),
            database.schema(UserModel.schema)
                .delete(),
        ])
    }
}
