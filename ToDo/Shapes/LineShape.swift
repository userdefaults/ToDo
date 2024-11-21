//
//  LineShape.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/17.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .init(x: rect.minX, y: rect.midY))
            path.addLine(to: .init(x: rect.maxX, y: rect.midY))
        }
    }
}
