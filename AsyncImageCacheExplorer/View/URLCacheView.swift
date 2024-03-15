//
//  URLCacheView.swift
//  AsyncImageCacheExplorer
//
//  Created by yusuga on 2024/03/15.
//

import SwiftUI
import Then

struct URLCacheView: View {

  @State private var urlCacheModel: URLCacheModel

  init(cache: URLCache) {
    urlCacheModel = .init(cache: cache)
  }

  private let formatter = ByteCountFormatter()
    .then {
      $0.allowedUnits = .useAll
      $0.countStyle = .file
    }

  var body: some View {
    Section("Memory Cache") {
      LabeledContent("Limit", value: formattedString(from: urlCacheModel.memoryCapacity))
      LabeledContent("In Use", value: formattedString(from: urlCacheModel.currentMemoryUsage))
    }
    Section("Disk Cache") {
      LabeledContent("Limit", value: formattedString(from: urlCacheModel.diskCapacity))
      LabeledContent("In Use", value: formattedString(from: urlCacheModel.currentDiskUsage))
    }
    Section("Cache Management") {
      Button("Delete", action: removeAllCaches)
        .foregroundStyle(Color(.systemRed))
      Button(
        action: refresh,
        label: {
          VStack(alignment: .leading, spacing: 4) {
            Text("Refresh")
            Text("Disk cache deletion is performed asynchronously")
              .font(.caption2)
          }
        }
      )
    }
  }
}

private extension URLCacheView {

  func formattedString(from bytes: Int) -> String {
    formatter.string(fromByteCount: Int64(bytes))
  }

  func refresh() {
    urlCacheModel.refresh()
  }

  func removeAllCaches() {
    urlCacheModel.removeAllCachedResponses()
  }
}

private struct PreviewView: View {

  let cache: URLCache
  @State private var refreshKey = UUID()

  init(cache: URLCache) {
    self.cache = cache

    // If not enough space, extra cache may not be used.
    cache.memoryCapacity = 1_024 * 1_024 * 2

    // Likely, setting below 5MB defaults to 10MB.
    cache.diskCapacity = 1_024 * 1_024 * 5
  }

  var body: some View {
    NavigationStack {
      List {
        URLCacheView(cache: cache)
          .id(refreshKey)
      }
      .navigationTitle("URLCache")

      Button("Add dummy cache") {
        let url = URL(string: "https://example.com/dummy_data" + UUID().uuidString)!
        let request = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let cachedResponse = CachedURLResponse(
          response: response,
          data: Data(count: 1_024 * 100)
        )

        cache.storeCachedResponse(cachedResponse, for: request)
        refreshKey = .init()
      }
    }
  }
}

#Preview {
  PreviewView(cache: .shared)
}
