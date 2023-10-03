//
//  FileSecListItem+.swift
//  DrBoxClientTest
//
//  Created by admin on 30.09.2023.
//

import Foundation
import SwiftUI

// List Item Cell
extension AppView {
    
    func getMetadateEntry(metadata : [String:Any]?) {
        if let meta = metadata {
            alert = Alert(title: "Metadata", message: String( meta.description ))
        } else {
            alert = Alert(title: "Metadata", message: "Not available")
        }
    }
    
    func getFolder(entry: Metadata) {
        Task<Void, Never> {
            startNetTask()
            do {
                list = try await client.listFolder(path: entry.pathLower)
                folder = entry.pathDisplay
            } catch {
                log.error("ListFolder failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopNetTask()
        }
    }
    
    func getImage(entry: Metadata) {
        Task<Void, Never> {
            startNetTask()
            do {
                list = try await client.listFolder(path: entry.pathLower)
                folder = entry.pathDisplay
            } catch {
                log.error("ListFolder failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopNetTask()
        }
    }
    
    func getEntry (entry: Metadata) {
        Task<Void, Never> {
            startNetTask()
            do {
                let data = try await client.downloadFile(path: entry.id)
                alert = Alert(
                    title: "Content",
                    message: String(data: data, encoding: .utf8) ?? data.base64EncodedString()
                )
            } catch {
                log.error("DownloadFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopNetTask()
        }
    }
    
    func replaceEntry (entry: Metadata) {
        Task<Void, Never> {
            startNetTask()
            do {
                _ = try await client.uploadFile(
                    path: entry.pathDisplay,
                    data: "Uploaded with overwrite at \(Date().formatted(date: .complete, time: .complete))"
                        .data(using: .utf8)!,
                    mode: .overwrite,
                    autorename: false
                )
            } catch {
                log.error("UploadFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopNetTask()
        }
    }
    
    func deleteEntry (entry: Metadata) {
        Task<Void, Never> {
            startNetTask()
            do {
                _ = try await client.deleteFile(path: entry.pathDisplay)
                if let entries = list?.entries {
                    list?.entries = entries.filter { $0.pathDisplay != entry.pathDisplay }
                }
            } catch {
                log.error("DeleteFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopNetTask()
        }
    }
}
