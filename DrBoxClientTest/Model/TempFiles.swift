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
                debugPrint("Temp vid file created \(url!.absoluteString)")
            } catch let error as NSError {
                debugPrint("Error: \(error.domain)")
                return nil
            }
        } else {
            return nil
        }
    }

    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: url!)
            debugPrint("Temp vid file remove \(url!.absoluteString)")
        } catch let error as NSError {
            debugPrint("Error: \(error.domain)")
        }
    }
    
    deinit {
        if autoDispose {
            deleteFile()
        }
    }
}
