//
//  ShowVideo.swift
//  DrBoxClientTest
//
//  Created by admin on 01.10.2023.
//

import SwiftUI
import _AVKit_SwiftUI

struct ShowVideo: View {
    @StateObject var loader: ImageProvider
    @State private var isSharePresented: Bool = false
    @State private var isExifPresented: Bool = false
    @State private var tempVideo : tempFileCopy? = nil
    @State var isPlaying: Bool = true
    
    internal init(entry: Metadata) {
        self.entry = entry
        _loader = StateObject(wrappedValue: ImageProvider(entry: entry))
    }
    
    var entry: Metadata
    
    var body: some View {
        VStack{
            ZStack (alignment: Alignment(horizontal: .leading, vertical: .top)) {
                if let data = loader.data, let tempVideo = tempFileCopy(data: data.data, entry: entry),
                   let url = tempVideo.url {
                    PlayerView(player: AVPlayer(url: url), isPlaying: $isPlaying)
                        .padding(-5)
                        .onAppear(perform: {
                            loader.data?.tempFile = tempVideo
                            let _ = loader.data?.exif
                        })
                }
                
                VStack (alignment: .leading) {
                    Text("File:").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundStyle(.white)
                    
                    Text(entry.name).font(.headline)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.4).lineLimit(1)
                        .scaledToFit()
                    
                    if loader.data == nil {
                        Text("Loading video ...\nbe paitient. ")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top, 20)
                        
                    }
                }
                .padding([.leading,.trailing], 15)
                .padding([.top, .bottom], 5)
                .background(RoundedRectangle(cornerRadius: 5.0).opacity(0.4).foregroundStyle(.blue))
                .opacity(0.7)
            }
            
            // share content
            if let data = loader.data, !isPlaying {
                HStack (alignment: .firstTextBaseline) {
                    Spacer()
                    Button { self.isExifPresented = true }
                label: { Label("Exif", systemImage: "camera") }
                        .sheet(isPresented: $isExifPresented, onDismiss: {
                            print("Dismiss")
                        }, content: {
                            if let meta = data.meta {
                                ExifDataView(items: meta)
                            }
                        })
                    
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
        .padding(5)
        .navigationTitle("Show Video")
        .onAppear(perform: {
            loader.loadFull()
        })
        .onDisappear(perform: {
            if let temp = loader.data?.tempFile {
                temp.deleteFile()
            }
        })
    }
}

struct PlayerView: View {
    var player : AVPlayer
    @Binding var isPlaying: Bool
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .frame(alignment: .center)
                .onDisappear(perform: {
                    NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                    player.pause()
                })
                .onAppear(perform: {
                    isPlaying = true
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main)
                    { _ in
                        player.seek(to: .zero)
                        player.play()
                        isPlaying = true
                    }
                    player.play()
                })
            
            Button {
                isPlaying ? player.pause() : player.play()
                isPlaying.toggle()
                player.seek(to: .zero)
            } label: {
                Image(systemName: isPlaying ? "stop" : "play")
                    .padding()
            }
        }
    }
}


//#Preview {
//    var entry : Metadata
//    ShowVideo(entry: entry)
//}
