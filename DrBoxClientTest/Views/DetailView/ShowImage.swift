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
    @State private var isExifPresented: Bool = false
    
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
            
            // share content
            if let data = loader.data {
                HStack (alignment: .firstTextBaseline) {
                    if let exif = data.exif {
                        Spacer()
                        Button { self.isExifPresented = true }
                    label: { Label("Exif", systemImage: "camera") }
                            .sheet(isPresented: $isExifPresented, onDismiss: {
                                print("Dismiss")
                            }, content: {
                                ExifDataView(items: exif)
                            })
                    }

                    Spacer()

                    Button { self.isSharePresented = true }
                label: { Label("Share", systemImage: "square.and.arrow.up") }
                        .sheet(isPresented: $isSharePresented, onDismiss: {
                            print("Dismiss")
                        }, content: {
                            if let tempFile = tempFileCopy(data: loader.data?.data, entry: entry), let url = tempFile.url {
                                ActivityViewController(activityItems: [url] )
                            }
                        })
                    Spacer()
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
