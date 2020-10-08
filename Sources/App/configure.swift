import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.directory.publicDirectory = app.directory.workingDirectory + "/dist"
    app.directory.viewsDirectory = app.directory.workingDirectory + "/dist"
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST")!,
        username: Environment.get("DATABASE_USERNAME")!,
        password: Environment.get("DATABASE_PASSWORD")!,
        database: Environment.get("DATABASE_NAME")!
    ), as: .psql)
    
    let modules: [Module] = [
        FrontendModule(),
        UsersModule(),
    ]
    
    app.views.use { app in app.views.plaintext }
    app.migrations.add(modules.flatMap { $0.migrations })
    try modules.map(\.router).forEach {
        try $0.boot(routes: app.routes)
    }
}
