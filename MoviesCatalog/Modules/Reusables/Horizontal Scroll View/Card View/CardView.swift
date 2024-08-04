//
//  CardView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import SwiftUI
import CachedAsyncImage

struct CardView: View {
    let movie: Movie

    var body: some View {
        ZStack {
            posterView
            VStack {
                gradientBackground {
                    infoView
                }

                Spacer()
            }
        }
        .frame(width: 120, height: 180)
        .cornerRadius(AppDefault.cornerRadius)
        .clipped()
    }

    private var infoView: some View {
        HStack() {
            HStack {
                Text(movie.releaseYear)
                    .font(.caption).bold()
            }
            Spacer()
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("\(movie.voteAverage, specifier: "%.1f")")
                .font(.caption).bold()
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
            Image(systemName: "film")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    CardView(movie: .mock)
}
