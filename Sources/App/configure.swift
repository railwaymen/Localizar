import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    try configureDirectories(app)
    try configureMiddlewares(app)
    try configureDatabase(app)
    try configureModules(app)
}

private func configureMiddlewares(_ app: Application) throws {
    app.middleware = .init()
    try configureCORS(app)
    app.middleware.use(ErrorMiddleware.default(environment: app.environment))
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
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
        ProjectsModule(),
        UsersModule(),
    ]
    
    app.migrations.add(modules.flatMap { $0.migrations })
    try modules.forEach {
        try $0.router.boot(routes: app.routes)
    }
}
