import Vapor
import Fluent

struct ProjectsController {
    func getAll(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(UserModel.self)
        
        return user.$projects
            .get(on: req.db)
            .mapEach { ProjectForm(model: $0).getOutput() }
            .flatMapThrowing { try Response.ok(body: $0) }
    }
    
    func getDetails(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(UserModel.self)
        let projectSlug = try req.parameters.require(ProjectModel.slugParameter)
        
        return user.$projects
            .query(on: req.db)
            .filter(\.$slug == projectSlug)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { ProjectForm(model: $0).getOutput() }
            .flatMapThrowing { try Response.ok(body: $0) }
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(UserModel.self)
        let form = try ProjectForm(req: req)
        
        return form.validate(on: req.db)
            .flatMapThrowing { try form.createModel() }
            .flatMap { project -> EventLoopFuture<ProjectModel> in
                project
                    .save(on: req.db)
                    .map { project }
            }
            .flatMap { $0.$users.attach(user, on: req.db) }
            .map { Response.noContent() }
    }
    
    func update(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(UserModel.self)
        let form = try ProjectForm(req: req)
    
        return form.validate(on: req.db)
            .flatMap {
                user.$projects.query(on: req.db)
                    .filter(\.$slug == form.slug)
                    .first()
                    .unwrap(or: Abort(.notFound))
            }
            .map { form.updateModel($0) }
            .map { _ in Response.noContent() }
    }
}
