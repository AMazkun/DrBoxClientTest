//
//  ImagePicker.swift
//  DrBoxClientTest
//
//  Created by admin on 02.10.2023.
//
import PhotosUI
import SwiftUI

let cache = DataCache()

func getSuggestedExtention(_ item : NSItemProvider) -> String {
    let words = (item.registeredContentTypes.first?.description ?? "").components(separatedBy: ".")
    var _ext: String = "jpg"
    
    if words.count > 1 {
        _ext = words[1]
        if _ext == "jpeg" {_ext = "jpg"}
        if _ext == "mpeg-4" {_ext = "mp4"}
    }
    return _ext
}

func getUploadFilename(item : NSItemProvider, tmpUrl: String = "") -> String {
    
    let name : String = item.suggestedName ?? "no_name"
    var ext = getSuggestedExtention(item)

    let  words1 = name.components(separatedBy: ".")
    if words1.count == 2, let last1 = words1.last, last1.lowercased() != ext {
        ext = last1
    }

    let words2 = tmpUrl.components(separatedBy: ".")
    if words2.count == 2, let last2 = words2.last, last2 != "" {
        ext =  last2
    }

//    if words2.count == 2 {
//        return tmpUrl
//    }
//
    let res = name.replacingOccurrences(of: "/", with: "-") + "." + ext

    debugPrint("Suggested FileName: name: \(res)")
    return res
}

func getFullUploadFilename(_ folder : String, name: String) -> String {
    var _name: String = "na"
    var res: String = ""
    
    _name = (name.replacingOccurrences(of: "/", with: "-"))
    
    if (folder == "na") || (folder == "") || (folder == "/") {
        res =  "/" + _name
    } else {
        res = folder + "/" + _name 
    }
    
    debugPrint("FULL UploadFilename: \(res)")
    return res
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

