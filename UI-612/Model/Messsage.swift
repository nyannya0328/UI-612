//
//  Messsage.swift
//  UI-612
//
//  Created by nyannyan0328 on 2022/07/14.
//

import SwiftUI

struct Message: Identifiable{
    var id: String = UUID().uuidString
    var message: String
    var isReply: Bool = false
    var emojiValue: String = ""
    var isEmojiAdded: Bool = false
}
