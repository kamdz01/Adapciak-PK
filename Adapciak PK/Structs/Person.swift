//
//  Person.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 24/07/2023.
//

import Foundation
import SwiftUI

struct Person: Codable, Identifiable {
    var id: String?
    var name: String?
    var subTitle: String?
    var content: String?
    var image: String?
    var phone: String?
}
