//
//  UIActivityViewController.swift
//  DrBoxClientTest
//
//  Created by admin on 02.10.2023.
//
import UniformTypeIdentifiers.UTType
import SwiftUI
import LinkPresentation

final class DataActivityItemSource: NSObject, UIActivityItemSource {
    private let data: NSData
    private let title: String
    private let subtitle: String?
    private let typeIdentifier: String

    init(data: NSData, title: String, subtitle: String? = nil, typeIdentifier: String) {
        self.data = data
        self.title = title
        self.subtitle = subtitle
        self.typeIdentifier = typeIdentifier

        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return title
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return data
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        return typeIdentifier
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()

        metadata.iconProvider = NSItemProvider(object: UIImage(named: "Logo")!)
        metadata.title = title
        if let subtitle = subtitle {
            metadata.originalURL = URL(fileURLWithPath: subtitle)
        }

        return metadata
    }
}



struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    @discardableResult
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

