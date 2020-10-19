import Vapor

struct TranslationsRouter: RouteCollection {
    private let controller: TranslationsController = .init()
    
    func boot(routes: RoutesBuilder) throws {
        let protectedRoutes = routes
            .grouped("v1")
            .grouped(UserTokenAuthenticator<UserTokenModel>())
            .grouped(UserModel.guardMiddleware())
        protectedRoutes.get("projects", .parameter(ProjectModel.slugParameter), "translations", use: controller.getWithPagination)
    }
}
