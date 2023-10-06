//
//  CashedImage.swift
//  DrBoxClientTest
//
//  Created by admin on 06.10.2023.
//

import AVKit
import Foundation

public struct videoMetadata: Sendable {
    public var metadata : [String : String]
}

public class CashedImage {
    internal init(data: Data? = nil, file_metadata: [String : Any]?, fileType: String = "", fileSize: Int = -1, tempFile: tempFileCopy? = nil ) {
        self.data = data
        self.file_metadata = file_metadata
        self.fileType = fileType
        self.fileSize = fileSize
        self.tempFile = tempFile
    }
    
    public var data: Data?
    public var file_metadata : [String : Any]?
    public var fileType: String = ""
    public var fileSize : Int = -1
    public var tempFile : tempFileCopy? = nil
    public var meta: NSDictionary?
    
    public var exif : NSDictionary? {
        get {
            if self.fileType == "photo" {
                return photoExif()
            } else if self.fileType == "video" {
                videoMetadata()
                return nil
            }
            return nil
        }
    }
    
    //    func assetLoad(callback: @escaping (String) -> Any) {
    //        Task {
    //            let result = await asset.load(.availableMetadataFormats)
    //            callback(result)
    //        }
    //    }
    
    
    private func photoExif() -> NSDictionary? {
        if let data = self.data {
            if let imageSource = CGImageSourceCreateWithData(data as CFData, nil) {
                if let imageProperties2 = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as NSDictionary? {
                    return imageProperties2
                }
            }
        }
        return nil
    }
    
    private func completion(_ meta: NSMutableDictionary) {
        self.meta = meta
    }
    
    private func printMetadata(meta: NSMutableDictionary, key : String, metadata: [AVMetadataItem]?) {
        if let metadata = metadata {
            let dic = NSMutableDictionary()
            
            for item in metadata {
                if let key = item.commonKey {
                    dic[key.rawValue as Any] = item.value
                }
                if let key = (item.key as? String) {
                    dic[key as Any] = item.value
                }
            }
            meta[key] = dic
        }

    }

    
    private func videoMetadata()  -> Void {
        if let tempFile = self.tempFile, let url = tempFile.url {
            let asset: AVAsset = AVAsset(url: url) // An asset object to inspect.
            
            Task{
                let meta: NSMutableDictionary = NSMutableDictionary()
                
                let duration = try? await asset.load(.duration)
                meta["Duration"] = String(format: "%.1f s", duration!.seconds)
                debugPrint("Duration =========================================")
                debugPrint(duration as Any)
                debugPrint()

                let commonMetadata = try? await asset.load(.commonMetadata)
                printMetadata(meta: meta, key: "Common Metadata", metadata: commonMetadata)
                debugPrint("Common Metadata ==================================")
                debugPrint(commonMetadata as Any)
                debugPrint()

                let metadata = try? await asset.load(.metadata)
                printMetadata(meta: meta, key: "Metadata", metadata: metadata)
                debugPrint("Metadata =========================================")
                debugPrint(metadata as Any)
                debugPrint()

                let availableFormats = try? await asset.load(.availableMetadataFormats)
                debugPrint("availableFormats =================================")
                debugPrint(availableFormats as Any)
                debugPrint()

                if let availableFormats = availableFormats {
                    var formats:[String] = []
                    for item in availableFormats {
                        formats.append(item.rawValue)
                    }
                    meta["Available Metadata Formats"] = formats
                }
                self.completion(meta)
            }
            
        }
    }
}
