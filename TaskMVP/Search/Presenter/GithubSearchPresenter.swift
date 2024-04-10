//
//  GithubSearchPresenter.swift
//  TaskMVP
//
//  Created by 井本智博 on 2024/04/10.
//

import Foundation

protocol GithubSearchPresenterInput {
    func searchText(searchText: String?)
    var numberOfItems: Int { get }
    func items(index: Int) -> GithubModel
}

protocol GithubSearchPresenterOutput: AnyObject {
    func update(loading: Bool)
    func update(models: [GithubModel])
}

class GithubSearchPresenter {

    private weak var output: GithubSearchPresenterOutput!

    private var models: [GithubModel]!

    var numberOfItems:Int { models.count }

    private var api: GithubAPIProtocol!

    init(output: GithubSearchPresenterOutput!, api: GithubAPIProtocol = GithubAPI.shared) {
        self.output = output
        self.api = api
        self.models = []
    }
}

extension GithubSearchPresenter: GithubSearchPresenterInput {

    func searchText(searchText: String?) {
        guard searchText != nil, searchText != "" else { return }
        output.update(loading: false)
        api.get(searchWord: searchText!) { result in
            self.output.update(loading: true)
            switch result {
            case .failure(let error):
                print(error)
            case .success(let items):
                self.models = items
                DLog(self.models)
                self.output.update(models: self.models)
            }
        }
    }

    func items(index: Int) -> GithubModel {
        return models[index]
    }

}

public func DLog(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line) {
    var filename: NSString = file as NSString
    filename = filename.lastPathComponent as NSString
    let text: String
    if let obj = obj {
        text = "[File:\(filename) Func:\(function) Line:\(line)] : \(obj)"
    } else {
        text = "[File:\(filename) Func:\(function) Line:\(line)]"
    }
    print(text)
}
