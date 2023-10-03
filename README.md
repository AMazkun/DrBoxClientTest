# DropBox Client SDK Test
Simple SwiftUI app to test DropBox Client SDK
Inspired and based on [DROP BOX SDK](https://github.com/darrarski/swift-dropbox-client)

## Features
- Login with Drop Box API

- Browse files in your account
  - style: continuous feed, thumbnails
  - overlay GO HOME button
  - backgrount network task information
  
- File actions:
  - Show details
  - Upload (holly sh... jpeg - is unsupported extension, blame Apple)
  - Download
  - Show metadata (no beauty, sorry)
  - Delete
  - Share file (Data Representation issues, not critical)

- File Detail View
  - Image: Pan and Zoom View, Share
  - Video: Autostart, Infinite loop play, Share

## Technical stack
- Architect MP(x), sorry
- SwiftUI, Combine
- Incremental feed load
- Loaded files(image and video) and thumbnails cashed, limited cash by size and files count
## How to install and use

Not easy, but possible
### 1. You need to register application on DropBox site 
to handle a unique Dropbox URL scheme for redirect following completion of the OAuth 2.0 authorization flow. 
This URL scheme should have the format db-<APP_KEY> (pay attention "db-" at the begining), where <APP_KEY> is your Dropbox app's app key, which can be found in the [App Console](https://dropbox.com/developers/apps). There you have to:
- register App 
- get <API_Key>
- set URL scheme "db-<APP_KEY>://your-app-name"
- set access permission for app
- upload some files in your box
Be patient - server will update with permissions in 30 min

### 2. Starting Xcode project, 
you should add the following code to your .plist file section URL:
```
<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>db-<APP_KEY></string>
            </array>
            <key>CFBundleURLName</key>
            <string></string>
        </dict>
    </array>
```
Also, you have to find and change code:
```
let client = DropboxClient.Client.live(
  config: .init(
    appKey: "<APP_KEY>",
    redirectURI: "db-<APP_KEY>://<your-name>"
  )
)
```
### 3. Use Swift Package Manager 
to add the DropboxClient library as a dependency to your project.
This app use such packedges:
DropboxClient

https://github.com/darrarski/swift-dropbox-client.git

https://github.com/pointfreeco/swift-dependencies.git

Debug HTTP Consol & Misc

https://github.com/kean/pulseLogHandler.git

https://github.com/kean/pulse.git


## Basic Dropbox HTTP API client
- Authorize access
- List folder
- Get file metadata
- Upload file
- Download file
- Delete file

Useful [Dropbox API v2 documetation](https://www.dropbox.com/developers/documentation/http/documentation)

