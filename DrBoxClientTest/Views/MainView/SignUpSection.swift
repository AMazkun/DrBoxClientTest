//
//  SignUpSection.swift
//  DrBoxClientTest
//
//  Created by admin on 29.09.2023.
//

import Dependencies
import SwiftUI

struct SignUpSection: View {
    @Binding var isSignedIn : Bool
    @Dependency(\.dropboxClient) var client
    
    var body: some View {
          Section("SignUp") {
            if !isSignedIn {
              Text("You are signed out")

              Button {
                Task {
                  await client.auth.signIn()
                }
              } label: {
                Text("Sign In")
              }
            } else {
              Text("You are signed in")

              Button(role: .destructive) {
                Task {
                  await client.auth.signOut()
                }
              } label: {
                Text("Sign Out")
              }
            }
          }

    }
}

#Preview {
    // @State var isSignedIn = false
    // return SignUpSection(isSignedIn: $isSignedIn)
    SignUpSection(isSignedIn: .constant(true))
}
