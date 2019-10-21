//
//  ViewController.swift
//  tenLongBookstore
//
//  Created by Henry on 2019/10/3.
//  Copyright © 2019 Henry. All rights reserved.
//

import UIKit
import Kingfisher


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var cacheQueryForSearchBarDismiss:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getBook()
        setNavigationBar()
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    
    let session = URLSession.shared
    var bookList = [BookShelf.List]()
    var allBook = [BookShelf.List]()
    
    func getBook() {
        guard let url = URL(string: "https://bookshelf.goodideas-studio.com/api") else {
            // 不能轉成 url
            return
        }
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let bookShelf = try decoder.decode(BookShelf.self, from: data)
                self.allBook = bookShelf.list
                self.bookList = self.allBook
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let book = bookList[indexPath.row]
        
        cell.bookName.text = book.name
        cell.bookPrice.text = "Price: \(book.sellPrice ?? "0")"
        
        let url = URL(string: book.image!)!
        //result 二分法
        KingfisherManager.shared.retrieveImage(with: url) { (result) in
            switch result {
            case .success(let s):
                cell.bookImage.image = s.image
            case .failure(let f):
                print(f.errorDescription!)
                cell.bookImage.image = nil
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "webViewController") as! WebViewController
        navigationController?.pushViewController(vc, animated: true)
        let book = bookList[indexPath.row]
        vc.urlString = book.link
        
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.bounds.width) / 2) - 30
        let height = (collectionView.bounds.height) / 2 * 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cacheQueryForSearchBarDismiss = searchText
        if searchText.isEmpty == false {
            bookList = allBook.filter({ $0.name!.contains(searchText) })
        }
        else {bookList = allBook}
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        cacheQueryForSearchBarDismiss = ""
        bookList = allBook
        collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = cacheQueryForSearchBarDismiss
    }
    
}
