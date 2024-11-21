//
//  MultilineTextFieldView.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/17.
//

import SwiftUI

struct MultilineTextFieldView: View {
    let titleKey: LocalizedStringKey
    @Binding var text: String
    let action: () -> Void
    
    var body: some View {
        if #available(iOS 16.0, *) {
            TextField(titleKey, text: $text, axis: .vertical)
        } else {
            ZStack {
                Text(text)
                    .padding(.vertical, 10)
                
                TextEditor(text: $text)
                    .padding(.horizontal, -5)
                    .overlay(alignment: .topLeading) {
                        if text.isEmpty {
                            Text(titleKey)
                                .foregroundStyle(.tertiary)
                                .padding(.top, 8)
                                .onTapGesture {
                                    action()
                                }
                        }
                    }
            }
        }
    }
}

#Preview {
    List {
        MultilineTextFieldView(titleKey: "Text", text: .constant(""), action: {})
    }
}
