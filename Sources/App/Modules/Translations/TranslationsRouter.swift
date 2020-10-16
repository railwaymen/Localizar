import Vapor

struct TranslationsRouter: RouteCollection {
    private let controller: TranslationsController = .init()
    
    func boot(routes: RoutesBuilder) throws {
    
    }
}
