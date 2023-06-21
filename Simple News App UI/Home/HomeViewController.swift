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
    
    var itemGroups: [HomeItemGroup] = [.covid, .topNews, .news]
    var covidNews: [Any] = [1]
    var topNews: [Any] = [1]
    var newsNew: [Any] = [1]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = itemGroups[section]
        
        switch group {
        case .covid:
            return covidNews.count
        case .topNews:
            return topNews.count
        case .news:
            return newsNew.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = itemGroups[indexPath.section]
        
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
//            cell.topConstraint.constant = indexPath.row == 0 ? 20 : 5
//            cell.bottomConstraint.constant = indexPath.row == covidNews.count - 1 ? 20 : 5
            return cell
        }
        else if group == .topNews {
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath) as! TopNewsViewCell
            
            let attributedTagLabel = NSMutableAttributedString(
                string: "3 Hours • Architecture",
                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: UIColor.gray])
            
            cell.labelTag.attributedText = attributedTagLabel
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "new_news_cell", for: indexPath) as! NewNewsViewCell
//            let attributedTagLabel = NSMutableAttributedString(
//                string: "3 Hours • Architecture",
//                attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold), .foregroundColor: UIColor.gray])
//
//            cell.judulLabel.attributedText = attributedTagLabel
            return cell
        }
    }
}
