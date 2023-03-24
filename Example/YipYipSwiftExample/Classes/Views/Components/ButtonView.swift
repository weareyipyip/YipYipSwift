//
//  ButtonView.swift
//  YipYipSwiftExample
//
//  Created by Lars Moesman on 22/03/2023.
//  Copyright © 2023 YipYip. All rights reserved.
//

import SwiftUI

internal struct ButtonView: View {
    
    internal class Configuration: ObservableObject {
        @Published internal var action: (() -> Void)?
        @Published internal var label: String
        
        internal init(action: (() -> Void)? = nil, label: String) {
            self.action = action
            self.label = label
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Stored properties
    // ----------------------------------------------------
    
    @ObservedObject internal var configuation: Configuration
    
    // ----------------------------------------------------
    // MARK: - Computed properties
    // ----------------------------------------------------
    
    private var action: (() -> Void)? {
        return self.configuation.action
    }
    
    private var label: String {
        return self.configuation.label
    }
    
    // ----------------------------------------------------
    // MARK: - (De)Initializer(s)
    // ----------------------------------------------------
    
    internal init(action: (() -> Void)? = nil, label: String) {
        self.configuation = Configuration(action: action, label: label)
    }
    
    internal init(configuration: Configuration) {
        self.configuation = configuration
    }
    
    // ----------------------------------------------------
    // MARK: - View
    // ----------------------------------------------------
    
    var body: some View {
        return Button(
            action: self.action ?? {},
            label: {
                Text(self.label)
                    .underline()
            }
        )
        .buttonStyle(DefaultButtonStyle(isDisabled: false))
    }
    
}


fileprivate struct DefaultButtonStyle: ButtonStyle {
    
    private let isDisabled: Bool
    
    fileprivate init(isDisabled: Bool) {
        self.isDisabled = isDisabled
    }
    
    fileprivate func makeBody(configuration: Self.Configuration) -> some View {
        let cornerRadius = 16.0
        let forgroundColor = Color.white
        let backgroundColor = Color.black
        return configuration.label
            .padding()
            .background(configuration.isPressed ? forgroundColor : backgroundColor)
            .foregroundColor(configuration.isPressed ?backgroundColor : forgroundColor)
            .lineLimit(1)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(backgroundColor, lineWidth: 2))
            .cornerRadius(cornerRadius)
            .animation(nil, value: UUID())
            .opacity(self.isDisabled ? 0.1 : 1)
    }
}
