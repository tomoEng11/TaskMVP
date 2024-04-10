//
//  MVCViewController.swift
//  TaskMVP
//
//  Created by  on 2021/3/10.
//

import UIKit

/*
 MVC構成になっています、MVP構成に変えてください

 Viewから何かを渡す、Viewが何かを受け取る　以外のことを書かない
 if, guard, forといった制御を入れない
 Presenter以外のクラスを呼ばない
 itemsといった変化するパラメータを持たない(状態を持たない)
*/
final class MVPSearchViewController: UIViewController {

  @IBOutlet private weak var searchTextField: UITextField!
  @IBOutlet private weak var searchButton: UIButton! {
    didSet {
      searchButton.addTarget(self, action: #selector(tapSearchButton(_sender:)), for: .touchUpInside)
    }
  }

  @IBOutlet private weak var indicator: UIActivityIndicatorView!

  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      tableView.register(UINib.init(nibName: MVPTableViewCell.className, bundle: nil), forCellReuseIdentifier: MVPTableViewCell.className)
      tableView.delegate = self
      tableView.dataSource = self
    }
  }

  var presenter: GithubSearchPresenterInput!

//  private var items: [GithubModel] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.isHidden = true
    indicator.isHidden = true
  }

    func inject(presenter: GithubSearchPresenterInput!) {
        self.presenter = presenter
    }

  @objc func tapSearchButton(_sender: UIResponder) {
      presenter.searchText(searchText: searchTextField.text)
  }

}

extension MVPSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
      Router.shared.showWeb(from: self, githubModel: presenter.items(index: indexPath.row))
  }
}

extension MVPSearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      DLog()
      return presenter.numberOfItems
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      DLog()
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MVPTableViewCell.className) as? MVPTableViewCell else {
      fatalError()
    }
      let githubModel = presenter.items(index: indexPath.row)
    cell.configure(githubModel: githubModel)
    return cell
  }
}

extension MVPSearchViewController: GithubSearchPresenterOutput {
    func update(loading: Bool) {
        DispatchQueue.main.async {
            self.indicator.isHidden = loading
            self.tableView.isHidden = !loading
        }
    }
    func update(models: [GithubModel]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            DLog()
        }
    }
}

