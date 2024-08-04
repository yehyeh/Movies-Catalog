//
//  View_Ex.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 04/08/2024.
//

import SwiftUI

extension View {
    func gradientBackground<Content: View>(startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom, @ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.dynamicText.opacity(0.6), .clear]),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            )
            .foregroundColor(.dynamicBackground)
    }
}
