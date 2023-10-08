//
//  ContentView.swift
//  DrBoxClientTest
//
//  Created by admin on 29.09.2023.
//

import Dependencies
import Logging
import SwiftUI
import PhotosUI
import Combine

struct AppView: View {
    
    @Dependency(\.dropboxClient) var client
    @State var list: ListFolder.Result?
    @State var folder: String = "/"
    @State var isSignedIn = false
    @State var alert: Alert?
    @State var isPHPresented: Bool = false
    @State var uploadTasks: Int = 0
    @State var uploadTasksDone: Bool = false
    @State var netTask: Int = 0
    
    var body: some View {
        ScrollViewReader { p in
            ZStack (alignment: .bottomTrailing) {
                
                // Base Layer
                Form {
                    SignUpSection(isSignedIn: $isSignedIn).body.id(1)
                    FilesSection.id(2)
                        .onChange(of: uploadTasksDone){ value in
                            withAnimation{
                                // scrolling to the text value present at bottom
                                if(uploadTasksDone){
                                    p.scrollTo(3, anchor: .top)
                                    uploadTasksDone = false
                                }
                            }
                        }
                }
                .textSelection(.enabled)
                .task {
                    for await isSignedIn in client.auth.isSignedInStream() {
                        self.isSignedIn = isSignedIn
                        if isSignedIn { loadFolder() }
                    }
                }
                
                // Upper Layer
                VStack (alignment: .trailing) {
                    
                    // Async tasks alert
                    if(netTask + uploadTasks > 0) {
                        Button {
                        } label: {
                            Text(   (netTask > 0     ? String("Net: \(netTask)") : "")
                                    + (uploadTasks > 0  ? String("  Uploads: \(uploadTasks)") : ""))
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 20)))
                            .shadow(radius: 4, x: 0, y: 4)
                            .opacity(0.6)
                            
                        }
                        .alignmentGuide(.bottom) { d in d[VerticalAlignment.top]}
                        .padding()
                    }
                    Spacer()
                    
                    // FLOAT Button
                    Button {
                        // go home
                        withAnimation{ p.scrollTo(1, anchor: .bottom) }
                    } label: {
                        Image(systemName: "house.fill")
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                            .opacity(0.6)
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItemGroup {
                   if !itsRoot(folder) {
                        Button {
                            loadParentFolder()
                        } label: {
                            Image(systemName: "arrow.turn.up.left")
                        }
                    }
                    
                    Button {
                        isPHPresented.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up.fill")
                    }
                    .sheet(isPresented: $isPHPresented)
                    {
                        PhotoPicker(itemPublisher: itemPublisher)
                    }
                    Button {
                        loadFolder()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }

        }
        .onOpenURL { url in
            Task<Void, Never> {
                do {
                    _ = try await client.auth.handleRedirect(url)
                } catch {
                    log.error("Auth.HandleRedirect failure", metadata: [
                        "error": "\(error)",
                        "localizedDescription": "\(error.localizedDescription)"
                    ])
                }
            }
        }
        .alert(
            alert?.title ?? "",
            isPresented: Binding(
                get: { alert != nil },
                set: { isPresented in
                    if !isPresented {
                        alert = nil
                    }
                }
            ),
            presenting: alert,
            actions: { _ in Button("OK") {} },
            message: { Text($0.message) }
        )
        .navigationTitle("\(getDisplayFolder(folder))")
    }
}

#Preview {
    AppView()
}
