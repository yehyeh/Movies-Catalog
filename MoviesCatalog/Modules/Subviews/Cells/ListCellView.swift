//
//  ListCellView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import SwiftUI

struct ListCellView: View {
    let movie: Movie

    var body: some View {
        HStack {
            posterView
            infoView
        }
    }

    private var infoView: some View {
        VStack(alignment: .leading) {
            Text(movie.title)
                .font(.headline)
            Text(movie.releaseYear)
                .font(.subheadline)
            HStack {
                Image(systemName: AppDefault.starSFPath)
                    .foregroundColor(.starApp)
                Text("\(movie.voteAverage, specifier: "%.1f")")
                    .font(.subheadline).bold()
            }
        }
    }

    @ViewBuilder
    var posterView: some View {
        if let url = movie.posterURL {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                    .cornerRadius(AppDefault.cornerRadius)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 120)
            }
        } else {
            Image(systemName: AppDefault.filmSFPath)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
                .foregroundColor(.placeholderApp)
        }
    }
}

#Preview {
    CardView(movie: .mock)
}
