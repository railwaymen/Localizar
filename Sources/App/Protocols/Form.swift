import Vapor
import Fluent

typealias InOutForm = InputForm & OutputForm

// MARK: - InputForm
protocol InputForm {
    associatedtype Model
    associatedtype ValidationError: CustomValidationError
    
    init()
    init(req: Request) throws
    
    func createModel() throws -> Model
    func validate(on database: Database) -> EventLoopFuture<ValidationError?>
}

extension InputForm {
    func validate(on database: Database) -> EventLoopFuture<ValidationError?> {
        database.eventLoop.future(nil)
    }
}

// MARK: - OutputForm
protocol OutputForm {
    associatedtype Model
    associatedtype Output: Encodable
    
    init(model: Model) throws
    
    func getOutput() throws -> Output
}
