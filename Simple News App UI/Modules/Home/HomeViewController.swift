//
//  HomeViewController.swift
//  Simple News App UI
//
//  Created by Erlangga Ardiansyah on 21/06/23.
//

import UIKit

enum HomeItemGroup {
    case covid
    case topNews
    case news
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var topNewsCollectionView: UICollectionView?
    weak var pageControl: UIPageControl?
    
    var itemGroups: [HomeItemGroup] = [.covid, .topNews, .news]
    var covidNews: [Any] = [1]
    var topNews: [News] = []
    var newsNew: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register XIB
        tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "news_view_cell")
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        // BUTTON PROFILE
        let button = UIButton()
        button.setImage(UIImage(named: "user_circle_40"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(self.buttonProfilePressed(_:)), for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barItem
        
        loadTopNews()
        loadNews()
        
    }
    
    //MARK: - HELPERS
    func loadTopNews() {
        NewsProvider.share.loadTopNews { response in
            switch response {
            case .success(let news):
                self.topNews = news
                self.tableView.reloadData()
                
            case .failure(let error):
//                print("Error load top news: \(error.localizedDescription)")
                print(String(describing: error))
            }
        }
    }
    
    func loadNews() {
        NewsProvider.share.loadNews { response in
            switch response {
            case .success(let news):
                self.newsNew = news
                self.tableView.reloadData()
                
            case .failure(let error):
//                print("Error load top news: \(error.localizedDescription)")
                print(String(describing: error))
            }
        }

    }
    
    // MARK: - ACTIONS
    @IBAction func buttonProfilePressed(_ sender: UIButton) {
        print("Button Pressed!")
    }
}

// Manage Table View Datasource
extension HomeViewController: UITableViewDataSource {
    
    // Jumlah section di table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemGroups.count // 3
    }
    
    // BERAPA CELL YANG MAU DITAMPILKAN DALAM SECTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = itemGroups[section]
        
        switch group {
        case .covid:
            return 1
        case .topNews:
            return 1
        case .news:
            return newsNew.count // 3 cell
        }
    }
    
    // Konfigurasi Isi pada setiap cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = itemGroups[indexPath.section]
        
        // Section Covid
        if group == .covid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "covid_cell", for: indexPath) as! CovidNewsViewCell
            let attributeText = NSMutableAttributedString(
                string: "Covid-19 News: ",
                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold),
                             NSAttributedString.Key.foregroundColor: UIColor(named: "textColorPrimary")!]
            )
            attributeText.append(NSMutableAttributedString(
                string: "See the latest coverage about Covid-19",
                attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .regular),
                             .foregroundColor: UIColor.gray]
            ))
            cell.covidLabelText.attributedText = attributeText
            
            return cell
        }
        
        // Section Top News is Using Collection View
        else if group == .topNews {
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! TopNewsViewCell
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            
            cell.subtitleLabel.text = "Top \(topNews.count) News of the day"
            
            self.topNewsCollectionView = cell.collectionView
            
            // Page Control
            cell.pageControl.currentPage = 0
            cell.pageControl.numberOfPages = topNews.count
            self.pageControl = cell.pageControl
            
            return cell
            
        }
        
        // News is Using Table View
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_view_cell", for: indexPath) as! NewsViewCell
            let news = newsNew[indexPath.item]
//            let topNews = topNews[indexPath.item]
            
            let attributedNewsTitle = NSMutableAttributedString(
                string: news.title ,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.black])
            cell.titleLabelNews.attributedText = attributedNewsTitle
            
            let attributedTagLabel = NSMutableAttributedString(
                string: [news.section, "\(news.published_date)"].joined(separator: " • "),
                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: UIColor.gray])
            cell.tagLabelNews.attributedText = attributedTagLabel
            
            if let imageUrl = news.media.last?.mediaMetadata.last?.url,
               let url = URL(string: imageUrl) {
                
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        let image = UIImage(data: data)
                        
                        DispatchQueue.main.async {
                            cell.thumbImages.image = image
                        }
                    }
                }
            }
            
//            cell.thumbImages.image = UIImage(named: news.imageNews)
            
            cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
            cell.bottomConstraint.constant = indexPath.row == newsNew.count - 1 ? 20 : 10

            return cell
        }
    }
}

// Data Source Collection View
extension HomeViewController: UICollectionViewDataSource {
    
    // Number of Section Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNews.count
    }
    
    // Customize each cell in section
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_cell", for: indexPath) as! TopNewsCollectionViewCell
        let topNews = topNews[indexPath.item]
    
        // LOAD IMAGE FROM API
        if let imageUrl = topNews.media.last?.mediaMetadata.last?.url,
           let url = URL(string: imageUrl) {
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
                
        // TITLE NEWS
        let newsLabelAttributed = NSMutableAttributedString(
            string: topNews.title,
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.black])
        cell.titleNews.attributedText = newsLabelAttributed
        
        // TAG NEWS LABEL
        let attributedTagLabel = NSMutableAttributedString(
            string: [topNews.section, "\(topNews.published_date)"].joined(separator: " • "),
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: UIColor.gray])
        
        cell.tagNews.attributedText = attributedTagLabel

        return cell
    }
}


// Collection View
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    // Define size of Collection View
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 270)
    }
    
    // Page Control Logic
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.topNewsCollectionView {
            let page = scrollView.contentOffset.x / scrollView.frame.width
            pageControl?.currentPage = Int(page)
        }
    }
}
