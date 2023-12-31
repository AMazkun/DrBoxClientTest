import Foundation
import UIKit.UIImage
import Combine

// Declares in-memory image cache
public protocol DataCacheType: AnyObject {
    // Returns the image associated with a given url
    func data(for url: URL) -> CashedImage?
    // Inserts the image of the specified url in the cache
    func insertData(_ image: CashedImage?, for url: URL)
    // Removes the image of the specified url in the cache
    func removeData(for url: URL)
    // Removes all images from the cache
    func removeAll()
    // Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> CashedImage? { get set }
}

public final class DataCache: DataCacheType {

    // 1st level cache, that contains encoded images
    private lazy var dataCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config

    public struct Config {
        public let countLimit: Int
        public let memoryLimit: Int

        public static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    public init(config: Config = Config.defaultConfig) {
        self.config = config
    }

    public func data(for url: URL) -> CashedImage? {
        lock.lock(); defer { lock.unlock() }
        // search for data
        if let data = dataCache.object(forKey: url as AnyObject) as? CashedImage {
            return data
        }
        return nil
    }

    public func insertData(_ data: CashedImage?, for url: URL) {
        guard let data = data else { return removeData(for: url) }

        lock.lock(); defer { lock.unlock() }
        dataCache.setObject(data as AnyObject, forKey: url as AnyObject, cost: data.data!.count)
    }

    public func removeData(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        dataCache.removeObject(forKey: url as AnyObject)
    }

    public func removeAll() {
        lock.lock(); defer { lock.unlock() }
        dataCache.removeAllObjects()
    }

    public subscript(_ key: URL) -> CashedImage? {
        get {
            return data(for: key)
        }
        set {
            return insertData(newValue, for: key)
        }
    }
}
