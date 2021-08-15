//
//  String+htmlString.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 14/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation
import AppKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let font = NSFont(name: "Overpass-Regular", size: 14)!
            let thisAttributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            let range = NSMakeRange(0, thisAttributedString.length)
            thisAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor(named: "altGhostTextColor")!, range: range)
            thisAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            return thisAttributedString
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
