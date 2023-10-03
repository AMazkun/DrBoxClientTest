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
        }
    }
    
    func itemPublisher (item: NSItemProvider, image: UIImage) {
        let fileName = getUploadFilename(folder, item: item)
        Task {
            // Retrieve selected asset in the form of Data
            startUploadTask()
            do {
                let what = try await client.uploadFile(
                    path: fileName,
                    data: image.jpegData(compressionQuality: 1.0)!,
                    mode: .add,
                    autorename: true
                )
                debugPrint("client.uploadFile: \(what)")
            } catch {
                log.error("UploadFile failure", metadata: [
                    "error": "\(error)",
                    "localizedDescription": "\(error.localizedDescription)"
                ])
            }
            stopUploadTask()
        }
    }
    
    @ViewBuilder
    var FilesSection: some View {
        
        Section(getDisplayFolder(folder)) {
            Button {
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
            } label: {
                Text(String(format: "\(getDisplayParentFolder(folder))"))
            }
            
            Button("UPLOAD") {
                isPHPresented.toggle()
            }
            .sheet(isPresented: $isPHPresented) {
                let configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
                PhotoPicker(itemPublisher: itemPublisher)
            }
            
            if(itsNoRoot(folder)) {
                Button {
                    Task<Void, Never> {
                        startNetTask()
                        do {
                            // lol
                            list = try await client.listFolder(path: folder)
                        } catch {
                            log.error("ListFolder failure", metadata: [
                                "error": "\(error)",
                                "localizedDescription": "\(error.localizedDescription)"
                            ])
                        }
                        stopNetTask()
                    }
                } label: {
                    Text("RELOAD")
                }
            }
        }
        
        if let list {
            if list.entries.isEmpty {
                Section {
                    Text("No entries")
                }
            } else {
                ForEach(list.entries) { entry in
                    ListItem(entry: entry, alert: $alert, getFolder: getFolder, deleteEntry: deleteEntry, getMetadataEntry: getMetadateEntry, replaceEntry: replaceEntry )
                }
            }
        }
    }
}
