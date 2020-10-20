import Vapor
import Fluent

struct TranslationsController {
    func getWithPagination(_ req: Request) throws -> EventLoopFuture<Response> {
        struct ProjectRequest: Decodable {
            let page: Int
            let perPage: Int
            let locale: String?
        }
        
        let projectSlug = try req.parameters.require(ProjectModel.slugParameter)
        let options = try req.query.decode(ProjectRequest.self)
        return try req.auth.require(UserModel.self)
            .$projects
            .query(on: req.db)
            .filter(\.$slug == projectSlug)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { project in
                project.$translations.query(on: req.db)
                    .filter(\.$localeID == options.locale ?? project.mainLocaleID)
                    .with(\.$createdBy)
                    .with(\.$project)
                    .paginate(PageRequest(page: options.page, per: options.perPage))
            }
            .flatMapThrowing { page -> TranslationForm.PageOutput in
                try TranslationForm.getPage(from: page)
            }
            .flatMapThrowing { try Response.ok(body: $0) }
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Response> {
        let form = try TranslationForm(req: req)
        return form.createModel(req: req)
            .map { _ in Response.noContent() }
    }
}
