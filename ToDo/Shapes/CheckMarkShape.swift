//
//  CheckMarkShape.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/17.
//

import SwiftUI

struct CheckMarkShape: Shape {
    let divider: CGFloat = 1 + (1/3)
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .init(x: rect.minX, y: rect.midY))
            path.addLine(to: .init(x: rect.maxX * (1/3), y: rect.maxY))
            path.addLine(to: .init(x: rect.maxX * (2/3), y: rect.midY))
            path.addLine(to: .init(x: rect.maxX, y: rect.minY))
        }
    }
}

#Preview("Checkmark") {
    CheckMarkShape()
        .trim(from: 0, to: 2)
        .stroke(style: .init(lineWidth: 40, lineCap: .round, lineJoin: .round))
        .fill(.black)
        .aspectRatio(1 + 1/3, contentMode: .fit)
}
