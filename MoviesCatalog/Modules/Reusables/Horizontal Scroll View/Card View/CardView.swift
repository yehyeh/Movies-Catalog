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
        ZStack {
            posterView
            VStack {
                gradientOverlay {
                    infoView
                }

                Spacer()
            }
        }
        .frame(width: 120, height: 180)
        .cornerRadius(16)
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
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
    }

    private func gradientOverlay<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.dynamicText.opacity(0.6), .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .foregroundColor(.dynamicBackground)
    }
}

#Preview {
    CardView(movie: .mock)
}
