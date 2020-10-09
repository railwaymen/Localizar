import Vapor

final class FrontendController {
    func index(_ req: Request) throws -> EventLoopFuture<View> {
        req.view.render("index.html")
    }
}
