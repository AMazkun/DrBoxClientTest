//
//  PHPickerCoordinator.swift
//  DrBoxClientTest
//
//  Created by admin on 04.10.2023.
//

import Foundation
import PhotosUI

class Coordinator: NSObject, PHPickerViewControllerDelegate {
    
    var parent: PhotoPicker
    private var itemPublisher : (NSItemProvider, Data?, String) -> ()
    
    init(parent: PhotoPicker, itemPublisher: @escaping (NSItemProvider, Data?, String) -> ()) {
        self.parent = parent
        self.itemPublisher = itemPublisher
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        parent.itemProviders = results.map(\.itemProvider)
        loadItems()
    }
    
    private func loadItems() {
        let dispatchGroup = DispatchGroup()
        
        for itemProvider in parent.itemProviders {
            dispatchGroup.enter()
            // mess due to errors
            // make sure we have a valid typeIdentifier
            guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier)
            else {
                debugPrint("PhotoPicker loadItems: Could not find type identifier")
                return
            }

            // get the oject according to the specific typeIdentifier
            if utType.conforms(to: .image) {
                self.loadImage(from: itemProvider, typeIdentifier: typeIdentifier)
            } else if utType.conforms(to: .movie) {
                self.loadVideo(from: itemProvider, typeIdentifier: typeIdentifier)
            }
            
            dispatchGroup.leave()

        }
        dispatchGroup.notify(queue: .main) {
            //onComplete(nil)
        }
    }
    
    
    func loadImage(from itemProvider: NSItemProvider, typeIdentifier: String) {
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { (url, error) in
            if let url = url {

                let data = NSData(contentsOf: url)
                let uploadFileName = getUploadFilename(item: itemProvider)
                debugPrint("PhotoPicker: loadImage uploadFileName: \(uploadFileName)")
                debugPrint("PhotoPicker: loadImage data: ", data?.count as Any)
                debugPrint(FileManager.default.fileExists(atPath: url.path))

                DispatchQueue.main.async {
                    self.itemPublisher(itemProvider, data as Data?, uploadFileName)
                }
            } else {
                if let error = error {
                    //onComplete(error)
                    debugPrint("PhotoPicker: loadImage error: ", error.localizedDescription)
                } else {
                    //onComplete(error)
                    debugPrint("PhotoPicker: loadImage No URL")
                }
            }
        }
    }
    
    private func loadVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
        // get selected local video file url
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            // handle errors
            var latestErrorDescription : String
            if let error = error {
                print(error.localizedDescription)
            }
            
            // make sure url is not nil
            guard let url = url else {
                latestErrorDescription = "Url is nil"
                debugPrint("loadVideo : \(latestErrorDescription)")
                return
            }
            
            do {
                // if the file alreay existe=s there remove it
                let tempURL = getTempURL(lastURLComponent: url.lastPathComponent)
                // try to save the file
                
                try FileManager.default.copyItem(at: url, to: tempURL)
                
                DispatchQueue.main.async {
                    // set video so it appears on the view
                    let uploadFileName = getUploadFilename(item: itemProvider)
                    let data = NSData(contentsOf: tempURL)
                    debugPrint("PhotoPicker: loadVideo uploadFileName: \(uploadFileName)")
                    debugPrint("PhotoPicker: loadVideo data: ", data?.length as Any)
                    debugPrint(FileManager.default.fileExists(atPath: url.path))

                    self.itemPublisher(itemProvider, data as Data?, uploadFileName)
                }
            } catch {
                // handle errors
                print(error.localizedDescription)
                latestErrorDescription = error.localizedDescription
                debugPrint("loadVideo : \(latestErrorDescription)")
            }
        }
    }
}
