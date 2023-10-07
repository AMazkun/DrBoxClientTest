//
//  ImageView.swift
//  DrBoxClientTest
//
//  Created by admin on 29.09.2023.
//

import SwiftUI
import Combine
import Dependencies

class ImageProvider: ObservableObject {
    internal init(entry: Metadata) {
        self.entry = entry
    }
    
    @Dependency(\.dropboxClient) var client
    @Published var data : CashedImage?
    public var entry: Metadata
    
    public var isFolder: Bool {
        get {return entry.tag.rawValue == "folder"}
    }

    public var isPicrure: Bool {
        get {
            if let fileType = data?.fileType {
                if fileType == "photo" { return true }
                if fileType == "" {
                    let words = entry.name.split(separator: ".")
                    let vidExt = ["jpg", "jpeg", "bmp", "png"]
                    if words.count > 1, let ext = words.last?.lowercased() , ext.contains(vidExt) { return true }
                }
            }
            return false
        }
    }

    public var isVideo: Bool {
        get {
            if let fileType = data?.fileType {
                if fileType == "video" { return true }
                if fileType == "" {
                    let words = entry.name.split(separator: ".")
                    let vidExt = ["mp4", "mov", "ts", "m4v"]
                    if words.count > 1, let ext = words.last?.lowercased() , ext.contains(vidExt) { return true }
                }
            }
            return false
        }
    }

    
    func loadThumbnail() {
        
        if let downloadable = entry.isDownloadable, !downloadable {
            DispatchQueue.main.async {
                self.data = CashedImage(data: (UIImage(systemName: "e.square" )?.pngData())!, file_metadata: nil, fileType: "na", fileSize: -1)
            }
            return
        }
        
        if entry.tag == Metadata.Tag.folder {
            DispatchQueue.main.async {
                self.data = CashedImage(data: (UIImage( named: "FolderIcon" )?.pngData())!, file_metadata: nil, fileType: "folder", fileSize: -1)
            }
            return
        }
        
        if let data = cache[URL(string: String("th:+\(entry.id)"))!] {
            DispatchQueue.main.async {
                self.data = data
            }
            return
        }
        
        Task<Void, Never> {
            do {
                //let data = try await client.downloadFile(path: entry.id)
                let path = entry.id
                let resource = [
                    ".tag": "path",
                    "path": path]
                let args = [ "format":  "jpeg",
                             "mode":    "strict",
                             "quality": "quality_80",
                             "resource": resource,
                             "size": "w256h256" ] as [String : Any]
                
                let arg = doEncodeSA(body: args)
                
                let data = try await client.getThumbnail(path: arg)
                
                debugPrint("THUMBNAIL Load \(entry.id) \(entry.name)")
                let fileType = (file_metadata! as Dictionary<AnyHashable,Any>)
                    .getValue(forKeyPath: ["media_info","metadata",".tag"]) as? String ?? ""
                debugPrint("file type = \(fileType)")
                let fileSize = (file_metadata!["size"] as? Int) ?? -1
                debugPrint("file size = \(fileSize)")
                
                
                DispatchQueue.main.async { [self] in
                    self.data = CashedImage(data: data, file_metadata: file_metadata, fileType: fileType, fileSize: fileSize)
                    cache[URL(string: String("th:+\(entry.id)"))!] = self.data
                }
                
                debugPrint(cache)
            } catch {
                log.error("DownloadFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
        }
    }
    
    
    func loadMokeVideo() {
        // ***************** ATTENTION ***************************
        // ***************** ABSOLUTE URL ************************
        let url = URL(string: "/Users/admin/Movies/boxer.mp4")
        var data : Data?
        do {
            debugPrint("loadFull Moke Video : \(url!.absoluteString)")
            data = try Data(contentsOf: url!) // assuming video is of Data type
        } catch let error as NSError {
            debugPrint("loadFull Moke Video Error: \(error.domain)")
        }
        if data == nil {
            debugPrint("loadFull Moke Video: No data")
            return
        }
        DispatchQueue.main.async {
            self.data = CashedImage(data: data, file_metadata: file_metadata, fileType: "video",
                                    fileSize: data!.count, fileName: url!.lastPathComponent)
        }
        return
    }
    
    func loadFull() {
        // get moke video for debug
        if entry.pathLower == "****" {
        }
        
        if entry.tag != Metadata.Tag.file {
            DispatchQueue.main.async {
                self.data = nil
            }
            return
        }
        
        if let data = cache[URL(string: entry.id)!] {
            DispatchQueue.main.async {
                self.data = data
            }
            return
        }
        
        Task<Void, Never> {
            do {
                let data = try await client.downloadFile(path: entry.id)
                
                debugPrint("FULL load \(entry.id) \(entry.name)")
                let fileType = (file_metadata! as Dictionary<AnyHashable,Any>)
                    .getValue(forKeyPath: ["media_info","metadata",".tag"]) as? String ?? ""
                debugPrint("file type = \(fileType)")
                let fileSize = (file_metadata!["size"] as? Int) ?? -1
                debugPrint("file size = \(fileSize)")
                
                
                DispatchQueue.main.async { [self] in
                    self.data = CashedImage(data: data, file_metadata: file_metadata, fileType: fileType, fileSize: fileSize, fileName: entry.name)
                    cache[URL(string: entry.id)!] = self.data
                }
            } catch {
                log.error("DownloadFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
        }
    }
}
