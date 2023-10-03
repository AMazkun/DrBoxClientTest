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
                VStack (alignment: .leading) {
                    Text("File:").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    Text("qwgouycwryucevetb.tgwtr").font(.title)
                        .minimumScaleFactor(0.4).lineLimit(1)
                        .scaledToFit()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10.0).opacity(0.2).foregroundStyle(.indigo))

            
            
            Image("X_57")
                .resizable()
                .scaledToFit()

            Spacer()
        }
        .padding()
        .navigationTitle("Show Image")
     }
}

#Preview {
    test()
}
