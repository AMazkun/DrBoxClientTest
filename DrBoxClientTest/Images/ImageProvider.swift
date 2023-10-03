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
    
    func loadThumbnail() {
        
        if let downloadable = entry.isDownloadable, !downloadable {
            DispatchQueue.main.async {
                self.data = CashedImage(data: (UIImage(systemName: "e.square" )?.pngData())!, file_metadata: nil, fileType: "na", fileSize: -1)
            }
            return
        }
        
        if entry.tag == Metadata.Tag.folder {
            DispatchQueue.main.async {
                self.data = CashedImage(data: (UIImage(systemName: "folder" )?.pngData())!, file_metadata: nil, fileType: "folder", fileSize: -1)
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
            } catch {
                log.error("DownloadFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
        }
    }
    func loadFull() {
        
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
                    self.data = CashedImage(data: data, file_metadata: file_metadata, fileType: fileType, fileSize: fileSize)
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
