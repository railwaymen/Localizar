import Vapor
import Fluent

struct ProjectsController {
    func getAll(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(UserModel.self)
        
        return user.$projects
            .get(on: req.db)
            .mapEach { CreateProjectForm(model: $0).output() }
            .flatMapThrowing { output in
                let data = try JSONEncoder().encode(output)
                return Response.Body(data: data)
            }
            .map { Response(status: .ok, body: $0) }
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(UserModel.self)
        let form = try CreateProjectForm(req: req)
        
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
            .flatMap { Response(status: .noContent).encodeResponse(for: req) }
    }
}
