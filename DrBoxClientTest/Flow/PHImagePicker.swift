//
//  PHImagePicker.swift
//  DrBoxClientTest
//
//  Created by admin on 02.10.2023.
//

import Foundation
import PhotosUI
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    internal init(itemPublisher: @escaping (NSItemProvider, Data?, String) -> (), itemProviders: [NSItemProvider] = []) {
        self.itemPublisher = itemPublisher
        self.itemProviders = itemProviders
    }
    
    private var itemPublisher : (NSItemProvider, Data?, String) -> ()
    typealias UIViewControllerType = PHPickerViewController
    
    var itemProviders: [NSItemProvider] = []
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 30
        //        configuration.filter = .any(of: [.images,.videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(parent: self, itemPublisher: itemPublisher)
    }
}

func askForPhotoLibraryPermission(locking: Bool, execute: @escaping ()->(), fail: @escaping ()->()) {
    let locker : NSLock = NSLock()
    let photos = PHPhotoLibrary.authorizationStatus()

    if photos == .notDetermined {
        if (locking) {locker.lock()}
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                //access granted
                execute()
            } else {
                fail()
            }
            if (locking) {locker.unlock()}
        })
    }
    if (locking) {locker.lock()}
}
