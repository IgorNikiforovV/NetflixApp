//
//  HomeViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 08.07.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    private var randomTrendingMovie: Content?
    private var headerView: HeroHeaderView?
    
    private let sectionTitles = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top rated"]
    
    private var navBarOffset: CGFloat = 0
    
    private var structureService = HomePageStructureService()
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self,
                       forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        structureService.fetchConentShelves {
            DispatchQueue.main.async {
                self.homeFeedTable.reloadData()
            }
        }
        
        view.addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureNavbar()
        
        configureHeroHeaderView()

        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -navBarOffset)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.transform = .identity
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
}

// MARK: Private methods

private extension HomeViewController {
    func configureNavbar() {
        let image = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeroHeaderView() {
        APIManager.shared.getSearchMovies { [weak self] result in
            switch result {
            case .success(let movies):
                let movie = movies.randomElement()
                self?.randomTrendingMovie = movie
                let viewModel = MovieViewModel(titleName: movie?.originalTitle ?? "", posterURL: movie?.posterPath ?? "" )
                self?.headerView?.configure(viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        structureService.conentShelves.keys.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Section.trendiongMovie.rawValue:
            guard let content = structureService.conentShelves[.trendiongMovie] else { break }
            cell.configure(contentItems: content)
        case Section.trendingTv.rawValue:
            guard let content = structureService.conentShelves[.trendingTv] else { break }
            cell.configure(contentItems: content)
        case Section.popular.rawValue:
            guard let content = structureService.conentShelves[.popular] else { break }
            cell.configure(contentItems: content)
        case Section.upcoming.rawValue:
            guard let content = structureService.conentShelves[.upcoming] else { break }
            cell.configure(contentItems: content)
        case Section.topRated.rawValue:
            guard let content = structureService.conentShelves[.topRated] else { break }
            cell.configure(contentItems: content)
        default:
            fatalError("Section number \(indexPath.section) not found!")
        }
        cell.delegate = self
        return cell
    }
}

// MARK: UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navBarOffset = offset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        header.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
}

// MARK: CollectionViewTableViewCellDelegate

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: PreviewViewModel) {
        let controller = PreviewViewController()
        controller.configure(model: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
