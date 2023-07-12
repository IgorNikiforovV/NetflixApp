//
//  HomeViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 08.07.2023.
//

import UIKit

enum Section: Int {
    case trendiongMovie = 0
    case trendingTv = 1
    case popular = 2
    case upcoming = 3
    case topRated = 4
}

final class HomeViewController: UIViewController {
    private let sectionTitles = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self,
                       forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        let heroHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = heroHeaderView
        configureNavbar()

        view.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(PreviewViewController(), animated: true)
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
}

// MARK: UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
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
            APIManager.shared.getTrendingMovie { result in
                switch result {
                case .success(let content):
                    cell.configure(contentItems: content)
                case .failure(let error):
                    print("Error in secrion 'trendiongMovie': \(error.localizedDescription)")
                }
            }
        case Section.trendingTv.rawValue:
            APIManager.shared.getTrendingTvs { result in
                switch result {
                case .success(let content):
                    cell.configure(contentItems: content)
                case .failure(let error):
                    print("Error in secrion 'trendingTv': \(error.localizedDescription)")
                }
            }
        case Section.popular.rawValue:
            APIManager.shared.getPopularMovies { result in
                switch result {
                case .success(let content):
                    cell.configure(contentItems: content)
                case .failure(let error):
                    print("Error in secrion 'popular': \(error.localizedDescription)")
                }
            }
        case Section.upcoming.rawValue:
            APIManager.shared.getUpcomingMovies { result in
                switch result {
                case .success(let content):
                    cell.configure(contentItems: content)
                case .failure(let error):
                    print("Error in secrion 'upcoming': \(error.localizedDescription)")
                }
            }
        case Section.topRated.rawValue:
            APIManager.shared.getToRatedMovies { result in
                switch result {
                case .success(let content):
                    cell.configure(contentItems: content)
                case .failure(let error):
                    print("Error in secrion 'topRated': \(error.localizedDescription)")
                }
            }
        default:
            fatalError("Section number \(indexPath.section) not found!")
        }
        
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

