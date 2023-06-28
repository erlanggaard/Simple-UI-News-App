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
            return covidNews.count // 1 cell
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
        else if group == .topNews {
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! TopNewsViewCell
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            
            self.topNewsCollectionView = cell.collectionView
            
            // Page Control
            cell.pageControl.currentPage = 0
            self.pageControl = cell.pageControl
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_view_cell", for: indexPath) as! NewsViewCell
            let news = newsNew[indexPath.item]
            
            let attributedNewsTitle = NSMutableAttributedString(
                string: news.title ,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.black])
            cell.titleLabelNews.attributedText = attributedNewsTitle
            
            let attributedTagLabel = NSMutableAttributedString(
                string: [news.section, "\(news.published_date)"].joined(separator: " • "),
                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: UIColor.gray])
            cell.tagLabelNews.attributedText = attributedTagLabel
            
//            cell.thumbImages.image = UIImage(named: news.imageNews)
            
            cell.topConstraint.constant = indexPath.row == 0 ? 20 : 10
            cell.bottomConstraint.constant = indexPath.row == newsNew.count - 1 ? 20 : 10

            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_cell", for: indexPath) as! TopNewsCollectionViewCell
        let topNews = topNews[indexPath.item]
        
//        cell.imageView.image = UIImage(named: topNews.imageNews)
        
        // TITLE NEWS
        let newsLabelAttributed = NSMutableAttributedString(
            string: topNews.title,
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold), .foregroundColor: UIColor.black]
        )
        cell.titleNews.attributedText = newsLabelAttributed
        
        // TAG NEWS LABEL
        let attributedTagLabel = NSMutableAttributedString(
            string: [topNews.section, "\(topNews.published_date)"].joined(separator: " • "),
            attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: UIColor.gray])
        
        cell.tagNews.attributedText = attributedTagLabel

        return cell
    }
}

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
