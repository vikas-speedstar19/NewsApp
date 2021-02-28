//
//  NewsListViewModel.swift
//  News App
//
//  Created by monty on 27/02/21.
//

import Foundation

protocol NewsListViewModelDelegate: class {

    func displayNews()

}

class NewsListViewModel {

    // MARK: - Properties

    var isMore: Bool = false
    var isWaiting: Bool = false
    weak var delegate: NewsListViewModelDelegate? = nil
    private var currentPageCount: Int = 0
    private var currentPage: Int = 1
    private var totalPageCount: Int = 0
    private var pageSize: Int = 10
    private var newsResponseData: NewsResponseModel?
    private var newsModelArray: [NewsModel]? = []

    // MARK: - View Model Methods

    func fetchNews() {
        isWaiting = true
        APIs.getNews(pageSize: pageSize, pageNumber: currentPage, completion: { (newsResponse) -> (Void) in
            self.isWaiting = false
            let totalResults = newsResponse?.totalResults ?? 0
            self.totalPageCount = Int((Double(totalResults) / 10.00).rounded())
            self.currentPageCount = newsResponse?.articles?.count ?? 0
            self.newsResponseData = newsResponse
            self.newsModelArray?.append(contentsOf: newsResponse?.articles ?? [])
            if self.currentPage < self.totalPageCount {
                self.currentPage += 1
                self.isMore = true
            } else {
                self.isMore = false
            }
            self.delegate?.displayNews()
        })
    }

    // MARK: - Private Helpers

    func getNewsCount() -> Int {
        return newsModelArray?.count ?? 0
    }

    func getAllNewsModel() -> [NewsModel] {
        return newsModelArray ?? []
    }

    func getNews(indexPath: IndexPath) -> NewsModel? {
        return newsModelArray?[indexPath.row]
    }

    func configueTableCell(indexPath: IndexPath, cell: NewsListCellTableViewCell) {
        guard let news = getNews(indexPath: indexPath) else {
            return
        }
        cell.newsCoverImageView.setImage(imageURL: URL(string: news.urlToImage ?? ""))
        cell.newsTitleLabel.text = news.title ?? "N/A"
        cell.newsDescriptionLabel.text = news.description ?? "N/A"
        cell.newsPublishLabel.text = getDate(dateTime: news.publishedAt ?? "N/A")
    }

    func configureCollectionCell(indexPath: IndexPath, cell: NewsListCellCollectionViewCell) {
        guard let news = getNews(indexPath: indexPath) else {
            return
        }
        cell.newsCoverImageView.setImage(imageURL: URL(string: news.urlToImage ?? ""))
        cell.newsTitleLabel.text = news.title ?? "N/A"
        cell.newsDescriptionLabel.text = news.description ?? "N/A"
        cell.newsPublishLabel.text = getDate(dateTime: news.publishedAt ?? "N/A")
    }

    private func getDate(dateTime: String) -> String {
        let startTimeString = dateTime
        let deFormatter = DateFormatter()
        deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let startTime = deFormatter.date(from: startTimeString)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: startTime ?? Date())
    }

}
