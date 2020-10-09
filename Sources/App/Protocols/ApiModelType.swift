import Vapor

protocol ApiModelType {
    associatedtype ApiModel: Codable
    func apiModel() throws -> ApiModel
}
