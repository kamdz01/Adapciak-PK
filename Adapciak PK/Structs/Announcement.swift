//
//  Announcement.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 06/07/2023.
//

import Foundation
import SwiftUI

struct Announcement: Codable, Identifiable {
    var id: String?
    var title: String?
    var subTitle: String?
    var content: String?
    var hidden: Bool?
    var date: String?
    var isImage: Bool?
    var priority: Bool?
}
