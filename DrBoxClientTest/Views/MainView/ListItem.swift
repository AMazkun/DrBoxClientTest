//
//  ListItem.swift
//  DrBoxClientTest
//
//  Created by admin on 01.10.2023.
//

import SwiftUI
import Dependencies

struct ListItem: View {
    @Dependency(\.dropboxClient) var client
    var entry: Metadata
    @StateObject var loader: ImageProvider
    @Binding var alert: Alert?
    @State private var showingDetail = false
    @State private var showingMetadata = false
    @State private var confirmDeletePreseting  = false
    
    
    var getFolder:      (_ : Metadata) ->()
    var getMetadataEntry:    (_ : [String:Any]?) ->()
    var deleteEntry:    (_ : Metadata) ->()
    var replaceEntry:    (_ : Metadata) ->()
    
    internal init(entry: Metadata, alert: Binding<Alert?>,
                  getFolder: @escaping (Metadata) -> (), deleteEntry: @escaping (Metadata) -> (),
                  getMetadataEntry: @escaping ([String:Any]?) -> (), replaceEntry: @escaping (Metadata) -> ()) {
        self.entry = entry
        _alert = alert
        self.getFolder = getFolder
        self.deleteEntry = deleteEntry
        self.getMetadataEntry = getMetadataEntry
        self.replaceEntry = replaceEntry
        
        _loader = StateObject(wrappedValue: ImageProvider(entry: entry))
    }
    
    var body: some View {
        Section {
            HStack {
                AsyncImageOwn(loader: loader)
                // show detail view
                    .onTapGesture {
                        if (loader.data != nil) {
                            if loader.isFolder {
                                getFolder(entry)
                                return
                            }
                            if loader.isPicrure || loader.isVideo {
                                self.showingDetail.toggle()
                            }
                        }
                    }
                // detail view depends
                    .sheet(isPresented: $showingDetail) {
                        if loader.isPicrure { ShowImage(entry: entry)
                        } else {
                        if loader.isVideo   { ShowVideo(entry: entry) } }
                    }
                
                // if file metadata exists
                if (loader.data != nil) {
                    VStack (alignment: .center, spacing: 10) {
                        Spacer()
                        
                        if let _ = loader.data?.file_metadata {
                            Button {
                                showingMetadata = true
                            } label: {
                                Text("Metadata")
                            }
                            .buttonStyle(.borderless)
                            .sheet(isPresented: $showingMetadata, content: {
                                let meta = NSMutableDictionary(dictionary: (loader.data?.file_metadata!)!)
                                ExifDataView(items: meta)
                           })
                        }
                        
                        //                        Spacer()
                        //                        Button {
                        //                            replaceEntry(entry)
                        //                        } label: {
                        //                            Text("Replace")
                        //                        }
                        //                        .buttonStyle(.borderless)
                        
                        Spacer()
                        
                        Button("Delete", role: .destructive) {
                            confirmDeletePreseting = true
                         }
                        .buttonStyle(.borderless)
                        .confirmationDialog("Are you sure?",
                          isPresented: $confirmDeletePreseting) {
                          Button("Delete item", role: .destructive) {
                              deleteEntry(entry)
                           }
                         }
                        
                        Spacer()
                        
                        Text(fileSizeToDisplay(loader.data!.fileSize))
                            .font(.subheadline)
                            .frame(alignment: .trailing)
                        Spacer()
                    }
                    .padding(.leading)
                } else {
                    // diffferent order that is duplicated
                    Spacer()
                    Button(role: .destructive) {
                        deleteEntry(entry)
                    } label: {
                        Text("Delete")
                    }
                    .buttonStyle(.borderless)
                    Spacer()
                }
            }
            .padding(.top)
            
            HStack (alignment: .lastTextBaseline) {
                VStack(alignment: .leading) {
                    Text("Tag").font(.caption).foregroundColor(.secondary)
                    Text(entry.tag.rawValue).font(.system(size: 14)).minimumScaleFactor(0.4).lineLimit(1)
                }
                VStack(alignment: .leading) {
                    Text("Name").font(.caption).foregroundColor(.secondary)
                    Text(entry.name).font(.system(size: 14)).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).lineLimit(1)
                }
            }
        }
        
        .onAppear(perform: {
            loader.loadThumbnail()
        })
    }
}
