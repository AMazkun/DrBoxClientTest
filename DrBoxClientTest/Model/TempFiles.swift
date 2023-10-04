//
//  TempFiles.swift
//  DrBoxClientTest
//
//  Created by admin on 02.10.2023.
//

import Foundation

public final class tempFileCopy {
    
    
    public var  url : URL?
    private var autoDispose : Bool = false
    
    init?(data: Data?, entry : Metadata, manualDispose: Bool = false) {
        self.autoDispose = manualDispose
        if let data = data {
            let tempDir = FileManager.default.temporaryDirectory
            let tempURL = tempDir.appendingPathComponent(entry.name)
            
            self.url = tempURL // or whatever extension the video is
            
            do {
                try data.write(to: url!) // assuming video is of Data type
                debugPrint("tempFileCopy: Temp vid file created \(url!.absoluteString)")
            } catch let error as NSError {
                debugPrint("tempFileCopy: Error: \(error.domain)")
                return nil
            }
        } else {
            return nil
        }
    }

    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: url!)
            debugPrint("tempFileCopy: Temp vid file remove \(url!.absoluteString)")
        } catch let error as NSError {
            debugPrint("tempFileCopy: Error: \(error.domain)")
        }
    }
    
    deinit {
        if autoDispose {
            deleteFile()
        }
    }
}

func removeTempFiles() {
    let fileManager = FileManager.default
    let temporaryDirectory = fileManager.temporaryDirectory
    try? fileManager
        .contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        .forEach { file in
            try? fileManager.removeItem(atPath: file.path)
        }
}

func getTempURL(lastURLComponent : String) -> URL {
    // get the documents directory
    let fileManager = FileManager.default
    let temporaryDirectory = fileManager.temporaryDirectory
    // create a target url where we will save our video
    let tempURL = temporaryDirectory.appendingPathComponent(lastURLComponent)
    
    // if the file alreay existe=s there remove it
    if FileManager.default.fileExists(atPath: tempURL.path) {
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    return tempURL
}
