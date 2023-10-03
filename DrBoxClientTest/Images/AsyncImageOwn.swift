//
//  AsyncImage.swift
//  DrBoxClientTest
//
//  Created by admin on 29.09.2023.
//

import SwiftUI
import AVKit

struct AsyncImageOwn: View {
    
    @ObservedObject var loader: ImageProvider
    var minWidth : CGFloat = 250;
    var minHeight : CGFloat = 200;
        
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack {
            if loader.data == nil {
                ZStack{
                    Rectangle()
                        .fill(.gray)
                        .cornerRadius(10)
                        .frame(minWidth: minWidth, minHeight: minHeight)
                    Text("Loading ... ")
                        .foregroundStyle(.white.gradient)
                }
            } else {
                ZStack{
                    Image(uiImage: UIImage(data: loader.data!.data!)!)
                        .resizable()
                        .scaledToFit()
                        .background(.gray)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 4))
                        .shadow(radius: 10)
                    if loader.data!.fileType == "video" {
                        ZStack {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50, alignment: .center)
                                .opacity(0.4)
                            Image(systemName: "video.fill")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black)
                                .frame(width: 30, height: 30, alignment: .center)
                                .opacity(0.5)
                        }
                        .position(x: 10, y: 5)
                     }
                }
            }
        }
        .frame(maxWidth: minWidth, maxHeight: minHeight)
    }
}
