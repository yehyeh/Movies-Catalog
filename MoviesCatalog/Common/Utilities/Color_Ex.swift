//
//  Color_Ex.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 04/08/2024.
//

import SwiftUI

extension Color {
    static let dynamicBackground = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
    })

    static let dynamicText = Color(UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
    })
}
