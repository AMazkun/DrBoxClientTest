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
                    PlayerView(player: AVPlayer(url: url))
                        .padding(-5)
                }
                
                VStack (alignment: .leading) {
                    Text("File:").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text(entry.name).font(.headline)
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
            if let _ = loader.data {
                Button { self.isSharePresented = true }
            label: { Label("Share", systemImage: "square.and.arrow.up") }
                    .sheet(isPresented: $isSharePresented, onDismiss: {
                        debugPrint("Dismiss ActivityViewController")
                    }, content: {
                        if let tempFile = tempFileCopy(data: loader.data?.data, entry: entry), let url = tempFile.url {
                            ActivityViewController(activityItems: [url] )
                        }
                    })
            }
        }
        .padding(5)
        .navigationTitle("Show Video")
        .onAppear(perform: {
            loader.loadFull()
        })
    }
}

struct PlayerView: View {
    var player : AVPlayer
    @State var isPlaying: Bool = true
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
                .frame(alignment: .center)
                .onDisappear(perform: {
                    NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                    player.pause()
                })
                .onAppear(perform: {
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main)
                    { _ in
                        player.seek(to: .zero)
                        player.play()
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
