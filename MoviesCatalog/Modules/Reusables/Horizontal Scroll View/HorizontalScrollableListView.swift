//
//  HorizontalScrollableListView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import SwiftUI

struct HorizontalScrollableListView: View {
    let items: [Movie]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    CardView(movie: item)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
    }
}

struct HorizontalScrollableListView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollableListView(items: [Movie.mock, Movie.mock, Movie.mock, Movie.mock, Movie.mock])
    }
}

