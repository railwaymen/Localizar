import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {    
    try configureCORS(app)
    try configureDirectories(app)
    try configureDatabase(app)
    try configureModules(app)
}

private func configureCORS(_ app: Application) throws {
    guard app.environment == .development else { return }
    let config = CORSMiddleware.Configuration.init(
        allowedOrigin: .all,
        allowedMethods: [.HEAD, .OPTIONS, .GET, .POST, .PUT, .PATCH, .DELETE],
        allowedHeaders: [
            .accept,
            .authorization,
            .contentType,
            .origin,
            .xRequestedWith,
            .init("Token"),
        ])
    app.middleware.use(CORSMiddleware(configuration: config))
}

private func configureDirectories(_ app: Application) throws {
    app.directory.publicDirectory = app.directory.workingDirectory + "/dist"
    app.directory.viewsDirectory = app.directory.workingDirectory + "/dist"
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}

private func configureDatabase(_ app: Application) throws {
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST")!,
        username: Environment.get("DATABASE_USERNAME")!,
        password: Environment.get("DATABASE_PASSWORD")!,
        database: Environment.get("DATABASE_NAME")!
    ), as: .psql)
}

private func configureModules(_ app: Application) throws {
    let modules: [Module] = [
        FrontendModule(),
        UsersModule(),
    ]
    
    app.migrations.add(modules.flatMap { $0.migrations })
    try modules.map(\.router).forEach {
        try $0.boot(routes: app.routes)
    }
}
