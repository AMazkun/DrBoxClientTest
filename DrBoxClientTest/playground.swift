//
//  test.swift
//  DrBoxClientTest
//
//  Created by admin on 02.10.2023.
//

import SwiftUI

struct test: View {
    var body: some View {
        VStack {
            ZStack (alignment: Alignment(horizontal: .leading, vertical: .top)) {
                ZoomableScrollView { Image("IMG_2894")
                        .scaledToFit()
                }
                .padding(-5.0)
                
                VStack (alignment: .leading) {
                    Text("File:").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                    
                    Text("ciysdxvfuocg.vyb").font(.headline)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.4).lineLimit(1)
                        .scaledToFit()
                }
                .padding([.leading,.trailing], 15)
                .padding([.top, .bottom], 5)
                .background(RoundedRectangle(cornerRadius: 5.0).opacity(0.4).foregroundStyle(.indigo))
                .opacity(0.7)
            }
            Label("Tap me to share", systemImage:  "square.and.arrow.up")
            }
        .padding(5)
        .navigationTitle("Show Image")
        }
    }

#Preview {
    test()
}
