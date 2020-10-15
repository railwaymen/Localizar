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
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(UserModel.self)
        let form = try ProjectForm(req: req)
        
        return form.validate(on: req.db)
            .flatMapThrowing { validationError -> ProjectModel in
                if let error = validationError {
                    throw error
                }
                return try form.createModel()
            }
            .flatMap { project -> EventLoopFuture<ProjectModel> in
                project
                    .save(on: req.db)
                    .map { project }
            }
            .flatMap { $0.$users.attach(user, on: req.db) }
            .map { Response.noContent() }
    }
}
