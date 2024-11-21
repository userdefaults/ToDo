//
//  CheckMarkView.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/17.
//

import SwiftUI

struct CheckMarkView: View {
    let isActive: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: .init(lineWidth: 2))
                .fill(.foreground)
            
            CheckMarkShape()
                .trim(from: 0, to: isActive ? 1 : 0)
                .stroke(style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .fill(.foreground)
                .aspectRatio(1 + 1/3, contentMode: .fit)
                .opacity(isActive ? 2 : 0)
                .scaleEffect(0.5)
        }
        .animation(.smooth, value: isActive)
    }
}

#Preview {
    CheckMarkView(isActive: true)
}
