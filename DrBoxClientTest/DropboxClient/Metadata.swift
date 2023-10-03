import Foundation

// responded metadete
var file_metadata : [String : Any]? = nil

public struct Metadata: Sendable, Equatable, Identifiable, Hashable {
  public enum Tag: String, Sendable, Equatable, Codable {
    case file, folder, deleted
  }

  public init(
    tag: Tag,
    id: String,
    name: String,
    pathDisplay: String,
    pathLower: String,
    clientModified: Date?,
    serverModified: Date?,
    isDownloadable: Bool?
  ) {
    self.tag = tag
    self.id = id
    self.name = name
    self.pathDisplay = pathDisplay
    self.pathLower = pathLower
    self.clientModified = clientModified
    self.serverModified = serverModified
    self.isDownloadable = isDownloadable
  }

  public var tag: Tag
  public var id: String
  public var name: String
  public var pathDisplay: String
  public var pathLower: String
  public var clientModified: Date?
  public var serverModified: Date?
  public var isDownloadable: Bool?
}

extension Metadata: Codable {
  enum CodingKeys: String, CodingKey {
    case tag = ".tag"
    case id
    case name
    case pathDisplay
    case pathLower
    case clientModified
    case serverModified
    case isDownloadable
  }
}
