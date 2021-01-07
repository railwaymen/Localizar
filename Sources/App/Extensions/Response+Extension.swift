import Vapor

extension Response {
    static func ok<T>(body: T) throws -> Response where T: Encodable {
        let body = try encodeToResponseBody(body)
        return Response(
            status: .ok,
            headers: ["Content-Type": "application/json"],
            body: body)
    }
    
    static func noContent() -> Response {
        Response(status: .noContent)
    }
    
    static func created<T>(body: T) throws -> Response where T: Encodable {
        let body = try encodeToResponseBody(body)
        return Response(
            status: .created,
            headers: ["Content-Type": "application/json"],
            body: body)
    }
    
    // MARK: - Private
    static private func encodeToResponseBody<T>(_ object: T) throws -> Response.Body where T: Encodable {
        let data = try JSONEncoder().encode(object)
        return Response.Body(data: data)
    }
}
