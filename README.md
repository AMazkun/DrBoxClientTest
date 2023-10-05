# DropBox Client SDK Test
Simple SwiftUI app to test DropBox Client SDK
Inspired and based on [DROP BOX SDK](https://github.com/darrarski/swift-dropbox-client)

| home                                                                   | net tasks info                                                         | incremetal feed download                                               |
| ---------------------------------------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| ![](https://github.com/AMazkun/DrBoxClientTest/blob/main/IMG_8859.jpg) | ![](https://github.com/AMazkun/DrBoxClientTest/blob/main/IMG_8857.jpg) | ![](https://github.com/AMazkun/DrBoxClientTest/blob/main/IMG_8854.jpg) |


| photo detail                                                           | video detail                                                           | share                                                                  |
| ---------------------------------------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| ![](https://github.com/AMazkun/DrBoxClientTest/blob/main/IMG_8858.jpg) | ![](https://github.com/AMazkun/DrBoxClientTest/blob/main/IMG_8866.jpg) | ![](https://github.com/AMazkun/DrBoxClientTest/blob/main/IMG_8871.jpg) |

## Features
- Login with Drop Box API
- PushWoosh Notification SDK Integration

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

## Known issues

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

PushWoosh SDK integration
https://github.com/Pushwoosh/Pushwoosh-XCFramework

### Useful screen shots
[Setup moments](https://github.com/AMazkun/DrBoxClientTest/tree/main/SetupScreens)
[Pushwoosh SDK](https://github.com/AMazkun/DrBoxClientTest/tree/main/PushWoosh)
## Basic Dropbox HTTP API client
- Authorize access
- List folder
- Get file metadata
- Upload file
- Download file
- Delete file

Useful [Dropbox API v2 documetation](https://www.dropbox.com/developers/documentation/http/documentation)

## PushWoosh Notification SDK
To integrate the Pushwoosh notification system you need:
- Have a paid developer account
- Generate a certificate and key for sending notifications
- Register and get a test account on the [website https://www.pushwoosh.com/](https://www.pushwoosh.com/)
  - Register your application [Create your project](https://docs.pushwoosh.com/platform-docs/first-steps/start-with-your-project/create-your-project)
  - get the API SDK key and integrate it into your application 
  - integrate into the application SDK [Swift Package Manager Setup](https://docs.pushwoosh.com/platform-docs/pushwoosh-sdk/ios-push-notifications/setting-up-pushwoosh-ios-sdk/swift-package-manager-setup)
Instructions on the SDK website, screenshots in the Pushwoosh package of the project
### Known Problems:
Failed to automatically register the test device: after scanning the QR Code URL Shema redirect to the application works and... silence

### How to remove PushWoosh Notification SDK
If you don't like to get deal with them, just:
- remove Pushwoosh SDK packege from project
- remove Notification taget and clear (remove AppDelegate.swift)
- remove App Target Capabilities see screenshots in Pushwoosh catalog here
- remove Info.plist Pushwoosh API key

## Tests / UI Tests
Some tests SDK recomended done, please check

Known issues:
- depends on you account at Drop Box
- not all tests running on enulyator 

[Test done on current commit 2023-10-03: screenshot](https://github.com/AMazkun/DrBoxClientTest/blob/main/Screenshot%202023-10-03%20at%2018.12.01.jpg)
