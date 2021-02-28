//
//  NewsDisplayViewController.swift
//  News App
//
//  Created by monty on 28/02/21.
//

import UIKit
import WebKit

class NewsDisplayViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var webKit: WKWebView!

    // MARK: - Properties

    var news: NewsModel? = nil

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadNews()
    }


    // MARK: - Private Helpers

    private func loadNews() {
        guard let news = self.news else {
            navigationController?.popViewController(animated: true)
            return
        }
        title = news.source?.name ?? "News"
        guard let url = URL(string: news.url ?? "") else {
            navigationController?.popViewController(animated: true)
            return
        }
        webKit.load(URLRequest(url: url))
    }

}
