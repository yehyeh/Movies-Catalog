//
//  CardView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import SwiftUI

struct CardView: View {
    let movie: Movie

    var body: some View {
        VStack {
            ZStack {
                posterView
                VStack {
                    gradientBackground {
                        infoView
                    }

                    Spacer()
                }
            }
            .cornerRadius(AppDefault.cornerRadius)
            .clipped()
            .shadow(radius: 1)

            Text(movie.title)
                .font(.subheadline).bold()
                .foregroundStyle(Color.dynamicText)
                .lineLimit(1)
        }
    }

    private var infoView: some View {
        HStack() {
            HStack {
                Text(movie.releaseYear)
                    .font(.subheadline)
            }
            Spacer()
            Image(systemName: AppDefault.starSFPath)
                .foregroundColor(.starApp)
            Text("\(movie.voteAverage, specifier: "%.1f")")
                .font(.subheadline)
        }
    }

    @ViewBuilder
    private var posterView: some View {
        if let url = movie.posterURL {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: AppDefault.filmSFPath)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.placeholderApp)
        }
    }
}

#Preview {
    CardView(movie: .mock)
}
