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
                    PlayerView(player: AVPlayer(url: url), isSharePresented: $isSharePresented, isExifPresented: $isExifPresented)
                        //.padding(-5)
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
        .sheet(isPresented: $isExifPresented, onDismiss: {
            print("Dismiss")
        }, content: {
            if let meta = loader.data!.meta {
                ExifDataView(items: meta)
            }
        })
        .sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            if let tempFile = tempFileCopy(data: loader.data?.data, entry: entry), let url = tempFile.url {
                ActivityViewController(activityItems: [url] )
            }
        })
    }
}

struct PlayerView: View {
    public var player : AVPlayer
    @State private var isPlaying: Bool = true
    @Binding var isSharePresented: Bool
    @Binding var isExifPresented: Bool

    var body: some View {
        VStack {
            VideoPlayer(player: player)
            // share content
            HStack (alignment: .firstTextBaseline) {
                Spacer()
                Button { isExifPresented = true }
            label: { Label("Info", systemImage: "video.fill") }
                Spacer()
                Button {
                    isPlaying.toggle()
                    if isPlaying {player.play()}
                    else {player.pause()}
                } label: {
                    Image(systemName: isPlaying ? "play" : "stop")
                        .padding()
                }
                Spacer()
                Button { isSharePresented = true }
            label: { Label("Share", systemImage: "square.and.arrow.up") }
                Spacer()
            }
            
        }
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
    }
}

struct StubView : View{
    internal init() {
        self.entry = Metadata(tag: .file, id: "****", name: "mokevideo.mp4",
                              pathDisplay: "/mokevideo.mp4", pathLower: "/mokevideo.mp4",
                              clientModified: Date.now, serverModified: Date.now,
                              isDownloadable: true)
    }
    
    var entry : Metadata
    
    var body: some View {
        ShowVideo(entry: entry)
    }
}

//#Preview {
//    StubView()
//}
