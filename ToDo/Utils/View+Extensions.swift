//
//  View+Extensions.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/17.
//

import SwiftUI

extension View {
    func customStrikethrough(_ isActive: Bool, color: Color = .secondary) -> some View {
        self
            .overlay {
                Line()
                    .trim(from: 0, to: isActive ? 1 : -0.1)
                    .stroke(style: .init(lineWidth: 2, lineCap: .round))
                    .fill(color)
            }
    }
}
