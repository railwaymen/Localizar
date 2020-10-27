import Vapor

struct TranslationsModule: Module {
    static let router: RouteCollection = TranslationsRouter()
}
