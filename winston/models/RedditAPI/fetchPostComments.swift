//
//  fetchPostComments.swift
//  winston
//
//  Created by Igor Marcossi on 28/06/23.
//

import Foundation
import Alamofire

extension RedditAPI {
  func fetchPost(subreddit: String, postID: String, sort: CommentSortOption = .confidence) async -> FetchPostCommentsResponse? {
    await refreshToken()
    if let headers = self.getRequestHeaders() {
      let params = FetchPostCommentsPayload(sort: sort.rawVal.value, limit: 25, depth: 3)
      
      let response = await AF.request(
        "\(RedditAPI.redditApiURLBase)/r/\(subreddit)/comments/\(postID.hasPrefix("t3_") ? String(postID.dropFirst(3)) : postID).json",
        method: .get,
        parameters: params,
        encoder: URLEncodedFormParameterEncoder(destination: .queryString),
        headers: headers
      )
        .serializingDecodable(FetchPostCommentsResponse.self).response
      switch response.result {
      case .success(let data):
        return data
      case .failure(let error):
        print(error)
        return nil
      }
    } else {
      return nil
    }
  }
  
  typealias FetchPostCommentsResponse = [Either<Listing<PostData>, Listing<CommentData>>?]
  
  struct FetchPostCommentsPayload: Codable {
    var sort: String
    var limit: Int
    var depth: Int
    var comment: String?
  }
}