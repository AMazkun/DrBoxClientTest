//
//  ImagePicker.swift
//  DrBoxClientTest
//
//  Created by admin on 02.10.2023.
//
import PhotosUI
import SwiftUI

func getUploadFilename (_ folder : String, item : NSItemProvider) -> String {
    let name = item.suggestedName ?? "no_name_"
    let words = (item.registeredContentTypes.first?.description ?? "").components(separatedBy: ".")
    debugPrint("getUploadFilename: \(name)")
    debugPrint("getUploadFilename: \(words)")
    
    var _ext: String = "jpg"
    var _name: String = "na"
    
    if words.count > 1 {
        _ext = words[1]
        if _ext == "jpeg" {_ext = "jpg"}
    } else {
        _ext = "jpg"
    }
    _name = (name.replacingOccurrences(of: "/", with: "-")) 
    _ext = "jpg"
    
    if (folder == "na") || (folder == "") {
        return "/" + _name + "." + _ext
    } else {
        return folder + "/" + _name + "." + _ext
    }
}

func itsNoRoot(_ folder: String) -> Bool {
    return !(folder == "/" || folder == "" || folder == "na")
}

func getParentFolder(_ folder: String) -> String {
    if ( folder == "na") {return "/"}
    if let index = folder.lastIndex(of: "/") {
        let firstPart = String(folder.prefix(upTo: index))
        return firstPart == "" ? "/" : firstPart
    }
    return "/"
}

func getDisplayParentFolder( _ folder: String) -> String {
    if (folder == "na") {return "GET HOME LIST"}
    if (folder == "/")  {return "HOME"}
    let res = getParentFolder(folder)
    return  "BACK " + res
}

func getDisplayFolder( _ folder: String) -> String {
    if ( folder == "na") {return "Files"}
    if ( folder == "/") {return "HOME Files"}
    return "Files in: " + folder
}

func fileSizeToDisplay(_ fileSize: Int) -> String {
    if (fileSize == -1) {return ""}
    if fileSize < 1024 {return String("\(fileSize) b")}
    if fileSize < 999 * 1024 {return String(format: "%.1f K", Double(fileSize) / 1024.0)}
    if fileSize < 999 * 1024 * 1024 {return String(format: "%.1f M", Double(fileSize) / 1024.0 / 1024.0)}
    if fileSize < 999 * 1024 * 1024 * 1024 {return String(format: "%.1f G", Double(fileSize) / 1024.0 / 1024.0 / 1024.0)}
    return String(format: "%.3f T", Double(fileSize) / 1024.0 / 1024.0 / 1024.0 / 1024.0)
}

func removeTempFiles() {
    let fileManager = FileManager.default
    let temporaryDirectory = fileManager.temporaryDirectory
    try? fileManager
        .contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        .forEach { file in
            try? fileManager.removeItem(atPath: file.path)
        }
}
