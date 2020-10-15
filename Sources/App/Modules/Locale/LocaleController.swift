import Vapor

struct LocaleController {
    func getAll(_ req: Request) throws -> EventLoopFuture<Response> {
        let outputs = Locale.all
            .map { LocaleForm(model: $0).getOutput() }
        return try Response.ok(body: outputs)
            .encodeResponse(for: req)
    }
}
