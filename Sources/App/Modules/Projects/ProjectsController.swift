import Vapor
import Fluent

struct ProjectsController {
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let form = try CreateProjectForm(req: req)
        return form.validate(on: req.db)
            .flatMapThrowing { validationError -> ProjectModel in
                if let error = validationError {
                    throw error
                }
                return form.createModel()
            }
            .flatMap { $0.save(on: req.db) }
            .flatMap { Response(status: .noContent).encodeResponse(for: req) }
    }
}
