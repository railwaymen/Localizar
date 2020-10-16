import Vapor

struct LocaleModule: Module {
    static let router: RouteCollection = LocaleRouter()
}
