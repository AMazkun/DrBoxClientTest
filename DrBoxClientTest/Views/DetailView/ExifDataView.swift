//
//  ExifDataView.swift
//  DrBoxClientTest
//
//  Created by admin on 05.10.2023.
//

import SwiftUI

struct ExifDataView: View {
    let items: NSDictionary
    
    internal init(items: NSDictionary) {
        self.items = items
    }
    
    @ViewBuilder func KeyValueCell(Key : String, Value:  Optional<Any>) -> some View {
        HStack(alignment:.top) {
            let header = Key + ":"
            Text(header)
                .font(.system(size: 10, weight: .semibold))
                .frame(width: 100)
            // Divider()
            if let Value = Value {
                Text(String(describing: Value))
                    .font(.system(size: 10, weight: .regular))
            } else  {
                Text("non")
                    .font(.system(size: 10, weight: .regular))
            }
        }
    }
    
    var body: some View {
        List {
            
            ForEach(items.allKeys.map{$0 as! String}, id: \.hashValue ) { Key in
                if !Key.contains("MakerApple") {
                    Section{
                        if items[Key] is NSDictionary {
                            DisclosureGroup{
                                ExifDataLevel2(items: items[Key] as! NSDictionary)
                            }
                        label: {
                            let header = Key.trimmingCharacters(in: ["{","}"])
                            Text(header).fontWeight(.heavy)
                        }
                        } else {
                            KeyValueCell(Key: Key, Value: items[Key])
                        }
                    }
                }
            }
            
        }
    }
    
    @ViewBuilder func ExifDataLevel2(items: NSDictionary) -> some View {
        ForEach(items.allKeys.map{$0 as! String}, id: \.hashValue ) { Key in
            if !Key.isEmpty {
                if items[Key] is NSDictionary {
                    DisclosureGroup {
                        ExifDataLevel3(items: items[Key] as! NSDictionary)
                    }
                label: {
                    Text(Key).fontWeight(.heavy)
                }
                } else {
                    KeyValueCell(Key: Key, Value: items[Key])
                }
            } else {
                Text("Invalid Key").fontWeight(.heavy)
            }
        }
    }
    
    @ViewBuilder func ExifDataLevel3(items: NSDictionary) -> some View {
        ForEach(items.allKeys.map{$0 as! String}, id: \.hashValue ) { Key in
            if items[Key] is String {
                HStack(alignment:.top) {
                    Text(Key + ":")
                        .font(.system(size: 12, weight: .semibold))
                    // Divider()
                    Text(items[Key] as! String)
                        .font(.system(size: 12, weight: .regular))
                }
            } else {
                KeyValueCell(Key: Key, Value: items[Key])
            }
        }
    }
}

struct Preview: View {
    let items: NSDictionary = [
        "header":[
            "key": "rrr-ccc",
            "option": "rhtyhetjyy",
        ],
        "request":[
            "application": "0DCDD-B7B9C",
            "hwid": "9CF19444-FB2F-4460-A8F6-4C351AF9B2AC",
            "device" : [
                "device_type": 1,
                "email": "anatoly.mazkun@gmail.com",
                "language": "en"
            ],
            
            "public_key": "BNmDO4BTKEMJqaqprTf7t/HBUd2BQ/orc88cc/scS5CFP6zhQGIHI1/GgRQD8c4kTxTEEF0quvIUiLQqoBY0/Qo=",
            "auth_token": "RlRmCCdGM/s7ouuhjKFzoQ=="
        ]
    ]
    
    var body: some View {
        ExifDataView(items: items)
    }
}

#Preview {
    Preview()
}
