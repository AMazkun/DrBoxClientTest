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
        VStack (alignment: .leading){
            Text("File:").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .frame(alignment: .leading)
                .padding(.top, 15)
            Text(entry.name).font(.title)
                .minimumScaleFactor(0.4).lineLimit(1)
                .scaledToFit()
        }
            Spacer()
            if let data = loader.data, let tempVideo = tempFileCopy(data: data.data, entry: entry), 
                let url = tempVideo.url {
                PlayerView(player: AVPlayer(url: url))
            } else {
                Text("Loading video ...\nbe paitient. ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            if let tempFile = tempFileCopy(data: loader.data?.data, entry: entry), let url = tempFile.url {
                ShareLink(item: (url)){
                    Label("Tap me to share", systemImage:  "square.and.arrow.up")
                }
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
