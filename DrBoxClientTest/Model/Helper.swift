//
//  Helper.swift
//  DrBoxClientTest
//
//  Created by admin on 29.09.2023.
//

import Foundation
import Photos

struct Alert: Equatable {
    var title: String
    var message: String
}

func doEncodeSA(body: [String: Any]) -> String {
    if let jsonData = try? JSONSerialization.data(withJSONObject: body) {
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    }
    return ""
}

// Encode [[String]]
func doEncodeAA(input : Encodable) -> String{
    do {
        let json = try JSONEncoder().encode(input)
        return String(decoding: json, as: UTF8.self)
    } catch {
        print(error)
    }
    return ""
}


//extension
extension String {
    func contains(_ strings: [String]) -> Bool {
        strings.contains { contains($0) }
    }
}


extension Dictionary where Key: Hashable, Value: Any {
    func getValue(forKeyPath components : Array<Any>) -> Any? {
        var comps = components;
        let key = comps.remove(at: 0)
        if let k = key as? Key {
            if(comps.count == 0) {
                return self[k]
            }
            if let v = self[k] as? Dictionary<AnyHashable,Any> {
                return v.getValue(forKeyPath : comps)
            }
        }
        return nil
    }
}
