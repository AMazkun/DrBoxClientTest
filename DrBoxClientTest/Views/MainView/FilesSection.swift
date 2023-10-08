//
//  filesSection.swift
//  DrBoxClientTest
//
//  Created by admin on 29.09.2023.
//

import Dependencies
import Logging
import SwiftUI
import PhotosUI

extension AppView {
    // indicators
    func startNetTask() {
        DispatchQueue.main.async { [self] in
            netTask += 1
        }
    }
    
    func stopNetTask() {
        DispatchQueue.main.async { [self] in
            netTask -= 1
        }
    }
    
    func startUploadTask() {
        DispatchQueue.main.async { [self] in
            uploadTasks += 1
        }
    }
    
    func stopUploadTask() {
        DispatchQueue.main.async { [self] in
            uploadTasks -= 1
            if uploadTasks == 0 {
                loadFolder()
                uploadTasksDone = true
            }
        }
    }
    
    func itemPublisher (item: NSItemProvider, data : Data?, uploadFileName : String) {
        let fileName = getFullUploadFilename(folder, name: uploadFileName)
        Task {
            // Retrieve selected asset in the form of Data
            startUploadTask()
            do {
                let what = try await client.uploadFile(
                    path: fileName,
                    data: data!,
                    mode: .add,
                    autorename: true
                )
                debugPrint("itemPublisher.uploadFile: \(what)")
            } catch {
                log.error("UploadFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
                debugPrint("itemPublisher.uploadFile: \(error)")
            }
            stopUploadTask()
        }
    }
    
    func loadFolder() {
        Task<Void, Never> {
            startNetTask()
            do {
                // lol
                list = try await client.listFolder(path: itsRoot(folder) ? "" : folder )
            } catch {
                log.error("ListFolder failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopNetTask()
        }
    }
    
    func loadParentFolder() {
        Task<Void, Never> {
            startNetTask()
            do {
                let parentFolder = getParentFolder(folder)
                // lol
                list = try await client.listFolder(path: (parentFolder == "/" ? "" : parentFolder))
                folder = parentFolder;
            } catch {
                log.error("ListFolder failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopNetTask()
        }
    }
    
    @ViewBuilder
    var FilesSection: some View {
        
        Section(getDisplayFolder(folder)) {
            
            if let list {
                if list.entries.isEmpty {
                    Section {
                        Text("No entries")
                    }
                } else {
                    ForEach(list.entries) { entry in
                        ListItem(entry: entry, alert: $alert, getFolder: getFolder, deleteEntry: deleteEntry, getMetadataEntry: getMetadateEntry, replaceEntry: replaceEntry )
                    }
                    Text("").id(3)
                }
            }
        }
    }
}
