//
//  UploadSession.swift
//  DrBoxClientTest
//
//  Created by admin on 08.10.2023.
//

import Foundation
//import SwiftyDropbox
/*
func testDropbox(token: String, secret: String){
    let session = DropboxManager(refreshToken: token, appKeySecret: secret)
    session.upload(file: NSHomeDirectory() + "/tmp/test2.txt", to: "/uploads")
}

func createDropboxToken(refreshToken:String, appKey:String) -> String {
    
    // Create the command for refreshing the token
    let dbRefreshCMD = "curl https://api.dropbox.com/oauth2/token -s -d grant_type=refresh_token -d refresh_token=\"\(refreshToken)\" -u \"\(appKey)\""
    
    // Execute the command and parse the response
    let task = Process()
    let outputPipe = Pipe()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", dbRefreshCMD]
    task.standardOutput = outputPipe
    task.launch()
    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let res = try! JSONSerialization.jsonObject(with: outputData, options: []) as! [String: Any]
    print(res)
    
    // Print a message indicating that the Dropbox access token has been updated
    print("\nUpdated Dropbox Access Token")
    
    // Create a DropboxClient using the new access token and return it
    let dropboxToken = res["access_token"] as! String
    print(dropboxToken)
    return dropboxToken
}

struct DropboxManager {
    let dbxClient: DropboxClient
    let accessToken: String
    let chunkSize: UInt64
    
    init(refreshToken dbToken: String, appKeySecret dbKey: String) {
        chunkSize = (4 * (1024 * 1024))
        accessToken = createDropboxToken(refreshToken: dbToken, appKey: dbKey)
//        dbxClient = DropboxClient(accessToken: self.accessToken)
        dbxClient = DropboxClient(accessToken: self.accessToken)
        
    }
    
    func upload(file filePath: String, to dbxLocation: String) {
        let fileURL = URL(filePath: filePath)
        let fileName = fileURL.lastPathComponent
        let randomSize = 5 * 1024 * 1024
        if (FileManager.default.createFile(atPath: filePath, contents: Data(count: randomSize), attributes: nil)) {
            print("File created successfully.")
        } else {
            print("File not created.")
        }
        let fileSize = try? FileManager.default.attributesOfItem(atPath: filePath)[.size] as? uint64
//        Check to see if file is smaller than chunksize
//        FIXME: now getting this error ---- Only get this error if I add user to dropboxclient creation in init
//        [request-id 5e4b4893ca1b4ace944138a9a1f4f399] Bad Input: Error in call to API function "files/upload_session/start": Unexpected select user header. Your app does not have permission to use this feature
        if fileSize! < chunkSize {
            dbxClient.files.upload(path: "\(dbxLocation)/\(fileName)", input: fileURL).response(completionHandler: { response, error in
                if let response = response {
                    print("File uploaded: \(response)")
                } else {
                    print("Error upload session: \(error!)")
                }
            })
            .progress { progressData in print(progressData) }
            print("small file")
        } else {
//            start the upload session
            let session = dbxClient.files.uploadSessionStart(input: fileURL)
                .response(completionHandler: { response, error in
                    if let result = response {
                        print(result)
                        var offset: UInt64 = 0
//                        Append chunks to file
                        while (offset <= (fileSize! - self.chunkSize)) {
                            //FIXME: sessionDeinitialized
                            self.dbxClient.files.uploadSessionAppendV2(cursor: Files.UploadSessionCursor(sessionId: result.sessionId, offset: offset), input: fileURL)
                                .response {response , error in
                                    if let response = response {
                                        print("File appended: \(response)")
                                    } else {
                                        print("Error appending data to file upload session: \(error!)")
                                    }
                                }
                                .progress { progressData in print(progressData) }
                            offset += self.chunkSize
                        }
//                        Finish upload with last chunk
                        self.dbxClient.files.uploadSessionFinish(cursor: Files.UploadSessionCursor(sessionId: result.sessionId, offset: fileSize!), commit: Files.CommitInfo(path: "\(dbxLocation)/\(fileName)"), input: fileURL)
                            .response { response, error in
                                if let result = response {
                                    print(result)
                                } else {
                                    print(error!)
                                }
                            }
                            .progress { progressData in print(progressData) }
                    } else {
                        // the call failed
                        print(error!)
                    }
                })
        }
    }
}
*/
