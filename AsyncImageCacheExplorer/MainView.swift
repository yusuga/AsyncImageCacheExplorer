//
//  MainView.swift
//  AsyncImageCacheExplorer
//
//  Created by yusuga on 2024/03/15.
//

import SwiftUI

struct MainView: View {


  private let columns = Array(repeating: GridItem(.flexible()), count: 6)
  private let cache: URLCache
  @State private var imageURLs = [URL]()
  @State private var refreshKey = UUID()

  init() {
    self.cache = URLCache.shared
    cache.memoryCapacity = 1_024 * 1_024 * 100
    cache.diskCapacity = 1_024 * 1_024 * 100
  }

  var body: some View {
    NavigationStack {
      List {
        URLCacheView(cache: cache)

        Section("Image Management") {
          Button("Add Image", action: addImage)
          Button("Re-render AsyncImages", action: { refreshKey = .init() })
        }

        Section("AsyncImages") {
          LazyVGrid(columns: columns, spacing: 20) {
            ForEach(imageURLs, id: \.self) { url in
              AsyncImage(url: url) { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
              } placeholder: {
                Color(.secondarySystemBackground)
              }
            }
          }
        }
        .id(refreshKey)
      }
      .navigationTitle("AsyncImageCacheExplorer")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

private extension MainView {

  func addImage() {
    imageURLs.append(
      URL(string: "https://dummyimage.com/500.jpg&text=\(imageURLs.count + 1)")!
    )
  }
}

#Preview {
  MainView()
}
