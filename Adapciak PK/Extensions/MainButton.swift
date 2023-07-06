//
//  MainButton.swift
//  Adapciak PK
//
//  Created by Kamil Dziedzic on 06/07/2023.
//

import Foundation
import SwiftUI

extension Text {
    func MainButton(ifActive: Bool = true, bgColor: Color = Color("FieldColor")) -> some View {
        if #available(iOS 15.0, *) {
            return self
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(bgColor)
                .background(.thinMaterial)
                .cornerRadius(10)
        } else {
            if(ifActive) {
                return self
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(bgColor)
                    .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
            }
            else {
                return self
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(bgColor)
                    .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    func MainButtonBold(ifActive: Bool = true, bgColor: Color = Color("FieldColor")) -> some View {
        return self
            .bold()
            .MainButton(ifActive: ifActive, bgColor: bgColor)
    }
}
