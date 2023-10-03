//
//  PHImagePicker.swift
//  DrBoxClientTest
//
//  Created by admin on 02.10.2023.
//

import Foundation

import SwiftUI
import PhotosUI

struct PHPickerStub: View {
    @State private var isPresented: Bool = false
    var body: some View {
        Button("Present Picker") {
            isPresented.toggle()
        }.sheet(isPresented: $isPresented) {
            let configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            PhotoPicker(itemPublisher: itemPublisher)
        }
    }
}

func itemPublisher (item: NSItemProvider, image: UIImage) {
    print(item.suggestedName as Any)
    print(item.registeredContentTypes.first?.description as Any)
    print(image.description)

}

class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    var parent: PhotoPicker
    private var itemPublisher : (NSItemProvider, UIImage) -> ()

    init(parent: PhotoPicker, itemPublisher: @escaping (NSItemProvider, UIImage) -> ()) {
        self.parent = parent
        self.itemPublisher = itemPublisher
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        parent.itemProviders = results.map(\.itemProvider)
        loadImage()
    }
    
    private func loadImage() {
        for itemProvider in parent.itemProviders {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        self.itemPublisher(itemProvider, image)
                    } else {
                        print("Could not load image", error?.localizedDescription ?? "")
                    }
                }
            }
        }
    }
}


struct PhotoPicker: UIViewControllerRepresentable {
    internal init(itemPublisher: @escaping (NSItemProvider, UIImage) -> (), itemProviders: [NSItemProvider] = []) {
        self.itemPublisher = itemPublisher
        self.itemProviders = itemProviders
    }
    
    private var itemPublisher : (NSItemProvider, UIImage) -> ()
    typealias UIViewControllerType = PHPickerViewController
    
    var itemProviders: [NSItemProvider] = []
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images
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

#Preview {
    PHPickerStub()
}
