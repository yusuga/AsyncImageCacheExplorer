//
//  URLCacheModel.swift
//  AsyncImageCacheExplorer
//
//  Created by yusuga on 2024/03/15.
//

import Foundation
import Observation

@Observable
final class URLCacheModel {

  let cache: URLCache

  var memoryCapacity: Int
  var currentMemoryUsage: Int

  var diskCapacity: Int
  var currentDiskUsage: Int

  init(cache: URLCache) {
    self.cache = cache
    memoryCapacity = cache.memoryCapacity
    currentMemoryUsage = cache.currentMemoryUsage
    diskCapacity = cache.diskCapacity
    currentDiskUsage = cache.currentDiskUsage
  }
}

extension URLCacheModel {

  func refresh() {
    memoryCapacity = cache.memoryCapacity
    currentMemoryUsage = cache.currentMemoryUsage
    diskCapacity = cache.diskCapacity
    currentDiskUsage = cache.currentDiskUsage
  }

  func removeAllCachedResponses() {
    cache.removeAllCachedResponses()
    refresh()
  }
}
