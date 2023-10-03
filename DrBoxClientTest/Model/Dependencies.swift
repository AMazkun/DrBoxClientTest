import Dependencies
import Logging
import Foundation

let log = Logger(label: Bundle.main.bundleIdentifier!)
let cache = DataCache()

extension Client: DependencyKey {
  public static let liveValue = Client.live(
    config: Config(
      appKey: "a7xoqu17o4gaole",
      redirectURI: "db-a7xoqu17o4gaole://amm-nnd-test"
    )
  )

  public static let previewValue: Client = {
    let isSignedIn = CurrentValueAsyncSequence(false)
    let entries = ActorIsolated<[Metadata]>([
      Metadata(
        tag: .file,
        id: "id:preview-1",
        name: "Preview-1.txt",
        pathDisplay: "/Preview-1.txt",
        pathLower: "/preview-1.txt",
        clientModified: Date(),
        serverModified: Date(),
        isDownloadable: true
      ),
      Metadata(
        tag: .file,
        id: "id:preview-2",
        name: "Preview-2.txt",
        pathDisplay: "/Preview-2.txt",
        pathLower: "/preview-2.txt",
        clientModified: Date(),
        serverModified: Date(),
        isDownloadable: true
      ),
      Metadata(
        tag: .file,
        id: "id:preview-3",
        name: "Preview-3.txt",
        pathDisplay: "/Preview-3.txt",
        pathLower: "/preview-3.txt",
        clientModified: Date(),
        serverModified: Date(),
        isDownloadable: true
      ),
    ])

    return Client(
      auth: .init(
        isSignedIn: { await isSignedIn.value },
        isSignedInStream: { isSignedIn.eraseToStream() },
        signIn: { await isSignedIn.setValue(true) },
        handleRedirect: { _ in false },
        refreshToken: {},
        signOut: { await isSignedIn.setValue(false) }
      ),
      listFolder: .init { _ in
        ListFolder.Result(
          cursor: "curor-1",
          entries: await entries.value,
          hasMore: false
        )
      },
      downloadFile: .init { params in
        "Preview file content for \(params.path)".data(using: .utf8)!
      },
      deleteFile: .init { params in
        let entry = await entries.withValue {
          let index = $0.firstIndex { $0.pathDisplay == params.path }!
          let entry = $0[index]
          $0.remove(at: index)
          return entry
        }
        return DeleteFile.Result(metadata: entry)
      },
      uploadFile: .init { params in
        FileMetadata(
          id: "id:preview-uploaded",
          name: "Preview-uploaded.txt",
          pathDisplay: "/Preview-uploaded.txt",
          pathLower: "/preview-uploaded.txt",
          clientModified: Date(),
          serverModified: Date(),
          isDownloadable: true
        )
      },
      getMetadata: .init { params in
        Metadata(
          tag: .file,
          id: "id:preview-uploaded",
          name: "Preview-uploaded.txt",
          pathDisplay: "/Preview-uploaded.txt",
          pathLower: "/preview-uploaded.txt",
          clientModified: Date(),
          serverModified: Date(),
          isDownloadable: true
        )
      }, 
      getThumbnail: .init { params in
           "Preview file content for \(params.path)".data(using: .utf8)!
         }
    )
  }()
}

extension DependencyValues {
  var dropboxClient: Client {
    get { self[Client.self] }
    set { self[Client.self] = newValue }
  }
}
