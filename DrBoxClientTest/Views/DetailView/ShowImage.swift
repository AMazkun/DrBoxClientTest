//
//  ShowImage.swift
//  DrBoxClientTest
//
//  Created by admin on 01.10.2023.
//

import SwiftUI

struct ShowImage: View {
    @StateObject var loader: ImageProvider
    @State private var isSharePresented: Bool = false
    
    internal init(entry: Metadata) {
        self.entry = entry
        _loader = StateObject(wrappedValue: ImageProvider(entry: entry))
    }
    
    var entry: Metadata
    
    var body: some View {
        VStack {
            ZStack (alignment: Alignment(horizontal: .leading, vertical: .top)) {
                ZoomableScrollView { AsyncFullImage(loader: loader)
                        .scaledToFit()
                }
                .padding(-5.0)
                
                VStack (alignment: .leading) {
                    Text("File:").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)

                    Text(entry.name).font(.headline)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.4).lineLimit(1)
                        .scaledToFit()
                }
                .padding([.leading,.trailing], 15)
                .padding([.top, .bottom], 5)
                .background(RoundedRectangle(cornerRadius: 5.0).opacity(0.4).foregroundStyle(.indigo))
                .opacity(0.7)
            }
            if let tempFile = tempFileCopy(data: loader.data?.data, entry: entry), let url = tempFile.url {
                ShareLink(item: (url)){
                    Label("Tap me to share", systemImage:  "square.and.arrow.up")
                }
            }
        }
        .padding()
        .navigationTitle("Show Image")
        .onAppear(perform: {
            loader.loadFull()
        })
    }
}


//#Preview {
//    var entry : Metadata
//
//    ShowImage(entry: entry)
//}
