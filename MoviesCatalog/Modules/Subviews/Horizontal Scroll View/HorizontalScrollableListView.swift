//
//  HorizontalScrollableListView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import SwiftUI

struct HorizontalScrollableListView<Item, Content>: View where Item: Identifiable, Content: View {
    let showsIndicators: Bool = false
    let items: [Item]
    let content: (Item) -> Content

    init(_ items: [Item], @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.content = content
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: showsIndicators) {
            HStack(spacing: 10) {
                ForEach(items) { item in
                    content(item)
                }
            }
            .padding()
        }
    }
}

struct HorizontalScrollableListView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollableListView([Movie.mock, Movie.mock, Movie.mock, Movie.mock, Movie.mock]) { item in
            CardView(movie: item)
                .shadow(radius: 5)
        }
    }
}

