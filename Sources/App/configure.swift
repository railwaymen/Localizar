import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST")!,
        username: Environment.get("DATABASE_USERNAME")!,
        password: Environment.get("DATABASE_PASSWORD")!,
        database: Environment.get("DATABASE_NAME")!
    ), as: .psql)
    
    app.migrations.add(CreateTodo())
    
    // register routes
    try routes(app)
}
