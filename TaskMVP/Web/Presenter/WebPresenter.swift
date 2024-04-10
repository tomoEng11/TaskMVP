//
//  WebPresenter.swift
//  TaskMVP
//
//  Created by 井本智博 on 2024/04/10.
//

import Foundation

protocol WebPresenterInput {
    func makeRequest()
}

protocol WebPresenterOutput: AnyObject {

    func load(request: URLRequest)
}

class WebPresenter: WebPresenterInput {
    weak var output: WebPresenterOutput!
    var model: GithubModel!

    init(output: WebPresenterOutput!, model: GithubModel!) {
        self.output = output
        self.model = model
    }
    
    func makeRequest() {
        guard
            let githubModel = model,
            let url = URL(string: githubModel.urlStr) else {
            return
        }
        output.load(request: URLRequest(url: url))
    }

}
