//
//  FloatingTextField.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 12/01/2023.
//

import Foundation
import SwiftUI

struct FloatingTextField: View {
    let title: String
    let text: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading) {
            if (!text.wrappedValue.isEmpty){
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            if #available(iOS 16.0, *) {
                TextField(title, text: text, axis: .vertical)
            } else {
                TextField(title, text: text)
            }
        }
        .animation(.easeOut(duration: 0.3))
    }
}
