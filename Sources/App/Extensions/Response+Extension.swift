import Vapor

extension Response {
    static func ok<T: Encodable>(body: T) throws -> Response {
        let data = try JSONEncoder().encode(body)
        let body = Response.Body(data: data)
        return Response(
            status: .ok,
            headers: ["Content-Type": "application/json"],
            body: body)
    }
    
    static func noContent() -> Response {
        Response(status: .noContent)
    }
}
