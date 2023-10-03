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

struct AppView: View {
    
    @Dependency(\.dropboxClient) var client
    @State var list: ListFolder.Result?
    @State var folder: String = "na"
    @State var isSignedIn = false
    @State var alert: Alert?
    @State var isPHPresented: Bool = false
    @State var uploadTasks: Int = 0
    @State var netTask: Int = 0
    
    var body: some View {
        ScrollViewReader { p in
            ZStack (alignment: .bottomTrailing) {
                Form {
                    SignUpSection(isSignedIn: $isSignedIn).body.id(1)
                    FilesSection
                }
                .textSelection(.enabled)
                .navigationTitle("App")
                .task {
                    for await isSignedIn in client.auth.isSignedInStream() {
                        self.isSignedIn = isSignedIn
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
                VStack (alignment: .trailing) {
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
                    
                    Button {
                        // go home
                        p.scrollTo(1)
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
        }
    }
}
#Preview {
    AppView()
}
