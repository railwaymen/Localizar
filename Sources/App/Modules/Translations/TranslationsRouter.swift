import Vapor

struct TranslationsRouter: RouteCollection {
    private let controller: TranslationsController = .init()
    
    func boot(routes: RoutesBuilder) throws {
        let routesV1 = routes
            .grouped("v1")
            .grouped(UserTokenAuthenticator<UserTokenModel>())
            .grouped(UserModel.guardMiddleware())
        routesV1.get("projects", .parameter(ProjectModel.slugParameter), "translations", use: controller.getWithPagination)
        routesV1.post("projects", .parameter(ProjectModel.slugParameter), "translations", use: controller.create)
    }
}
