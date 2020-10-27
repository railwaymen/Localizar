import Vapor

struct TranslationsRouter: RouteCollection {
    private let controller: TranslationsController = .init()
    
    func boot(routes: RoutesBuilder) throws {
        let routesV1 = routes
            .grouped("v1")
            .grouped(UserTokenAuthenticator<UserTokenModel>())
            .grouped(UserModel.guardMiddleware())
            .grouped("projects", .parameter(ProjectModel.slugParameter), "translations")
        routesV1.get(use: controller.getWithPagination)
        routesV1.post(use: controller.create)
        routesV1.delete(.parameter(TranslationModel.idParameter), use: controller.delete)
    }
}
