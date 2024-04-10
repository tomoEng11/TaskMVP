//
//  Router.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import UIKit

/*
 MVC構成用のUtilityです
 PresenterとViewControllerを繋ぐ処理はここに書きます
 本来はここもProtocolがいいですが、模範解答もprotocolは導入してません
 */

final class Router {
  static let shared = Router()
  private init() {}

  private var window: UIWindow?

  func showRoot(window: UIWindow) {
    guard let vc = UIStoryboard.init(name: "MVPSearch", bundle: nil).instantiateInitialViewController() as? MVPSearchViewController else {
      return
    }
      let presenter = GithubSearchPresenter(output: vc)
      vc.inject(presenter: presenter)
    let nav = UINavigationController(rootViewController: vc)
    window.rootViewController = nav
    window.makeKeyAndVisible()
    self.window = window
  }

  func showWeb(from: UIViewController, githubModel: GithubModel) {
    guard let web = UIStoryboard.init(name: "Web", bundle: nil).instantiateInitialViewController() as? WebViewController else {
      return
    }

      let presenter = WebPresenter(output: web, model: githubModel)
      web.inject(presenter: presenter)
    show(from: from, to: web)
  }

  private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil){
    if let nav = from.navigationController {
      nav.pushViewController(to, animated: true)
      completion?()
    } else {
      from.present(to, animated: true, completion: completion)
    }
  }
}
