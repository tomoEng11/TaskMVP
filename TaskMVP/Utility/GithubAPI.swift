//
//  GithubAPI.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import Foundation

/*
 MVC構成用のUtilityです
 コンポーネントが増えてくるアーキテクチャでは基本Protocolで連携して疎結合にしましょう
 */

enum GithubError: Error {
  case error
}

protocol GithubAPIProtocol {
    func get(searchWord: String, completion: ((Result<[GithubModel], GithubError>) -> Void)?)
}

final class GithubAPI: GithubAPIProtocol {
  static let shared = GithubAPI()

  private init() {}

  func get(searchWord: String, completion: ((Result<[GithubModel], GithubError>) -> Void)? = nil) {
    guard searchWord.count > 0 else {
      completion?(.failure(.error))
      return
    }
    let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)&sort=stars")!
    let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
      guard let data = data,
            let githubResponse = try? JSONDecoder().decode(GithubResponse.self, from: data),
            let models = githubResponse.items else {
        completion?(.failure(.error))
        return
      }
      completion?(.success(models))
    })
    task.resume()
  }
}
