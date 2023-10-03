//
//  AsyncFullImage.swift
//  DrBoxClientTest
//
//  Created by admin on 01.10.2023.
//

import SwiftUI
import PDFKit

struct AsyncFullImage: View {
    @ObservedObject var loader: ImageProvider
    @State var scaledFrame: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack {
            if loader.data == nil {
                ZStack{
                    Text("Loading ... ")
                }
            } else {
                    Image(uiImage: UIImage(data: (loader.data?.data)!)!)
                    .resizable()
             }
        }
    }
}



