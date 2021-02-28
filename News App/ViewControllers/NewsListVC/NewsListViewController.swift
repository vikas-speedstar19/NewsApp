//
//  NewsListViewController.swift
//  News App
//
//  Created by monty on 27/02/21.
//

import UIKit

class NewsListViewController: UIViewController {

    // MARK: - Constants

    private let navigationTitle = "News App"
    private let tableCellIdentifier = "NewsListCellTableViewCell"
    private let collectionCellIdentifier = "NewsListCellCollectionViewCell"
    private let newsItemCellSize = CGSize(width: 200.0, height: 250.0)
    private let newsItemCellSpacing: CGFloat = 8.0
    private let tableViewCellHeight: CGFloat = 150.0
    private let listModeTitle = "List"
    private let gridModeTitle = "Grid"
    private var isListMode: Bool = false

    // MARK: - Properties

    private var viewModel: NewsListViewModel? = nil
    private var listSwitchBarButton: UIBarButtonItem? = nil

    // MARK: - IBOutlets

    @IBOutlet weak var tableViewHolder: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionViewHolder: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModelAndFetchNews()
        showCollectionView()
    }

    // MARK: - Private Helpers

    private func setupUI() {
        setupNavigationBar()
        setupTableView()
        setupCollectionView()
    }

    private func setupNavigationBar() {
        title = navigationTitle
        listSwitchBarButton = UIBarButtonItem(title: listModeTitle, style: .plain, target: self, action: #selector(switchGalleryMode))
        navigationItem.rightBarButtonItem = listSwitchBarButton
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: tableCellIdentifier, bundle: nil),
                           forCellReuseIdentifier: tableCellIdentifier)
        tableView.tableFooterView = UIView()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: collectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionCellIdentifier)

        let numberOfItemsPerRow: CGFloat = 2
        let screenWidth = floor((UIScreen.main.bounds.width) - (numberOfItemsPerRow - 1) * newsItemCellSpacing)
        let width: CGFloat = screenWidth / numberOfItemsPerRow
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(newsItemCellSize.height))
        collectionViewFlowLayout.sectionInset = .zero
        collectionViewFlowLayout.minimumLineSpacing = newsItemCellSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = newsItemCellSpacing
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
    }

    private func setupViewModelAndFetchNews() {
        viewModel = NewsListViewModel()
        viewModel?.delegate = self
        showLoadingView()
        viewModel?.fetchNews()
    }

    private func showTableView() {
        tableViewHolder.isHidden = false
        collectionViewHolder.isHidden = true
    }

    private func showCollectionView() {
        tableViewHolder.isHidden = true
        collectionViewHolder.isHidden = false
    }

    private func showLoadingView() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = tableView.isHidden
        collectionView.isHidden = collectionView.isHidden
    }

    private func hideLoadingView() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = tableView.isHidden
        collectionView.isHidden = collectionView.isHidden
    }

    private func displayNews(indexPath: IndexPath) {
        let vc = NewsDisplayViewController()
        guard let selectedNews = viewModel?.getNews(indexPath: indexPath) else { return }
        vc.news = selectedNews
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Actions

    @objc private func switchGalleryMode() {
        if isListMode {
            listSwitchBarButton?.title = gridModeTitle
            showCollectionView()
        } else {
            listSwitchBarButton?.title = listModeTitle
            showTableView()
        }
        self.isListMode = !isListMode

        if isListMode {
            listSwitchBarButton?.title = gridModeTitle
        } else {
            listSwitchBarButton?.title = listModeTitle
        }
    }

}

// MARK: - UITableViewDataSource

extension NewsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNewsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier) as? NewsListCellTableViewCell else {
            return UITableViewCell()
        }
        viewModel?.configueTableCell(indexPath: indexPath, cell: cell)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }

}

// MARK: - UITableViewDelegate

extension NewsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayNews(indexPath: indexPath)
    }

}

// MARK: - UICollectionViewDataSource

extension NewsListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getNewsCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as? NewsListCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        viewModel?.configureCollectionCell(indexPath: indexPath, cell: cell)
        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension NewsListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayNews(indexPath: indexPath)
    }

}

// MARK: - HomeViewModelDelegate

extension NewsListViewController: NewsListViewModelDelegate {

    func displayNews() {
        DispatchQueue.main.async {
            self.hideLoadingView()
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }

}

// MARK: - UIScrollViewDelegate

extension NewsListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        if isReachingEnd {
            if !(viewModel?.isWaiting ?? false) && (viewModel?.isMore ?? false) {
                viewModel?.fetchNews()
            }
        }
    }

}
