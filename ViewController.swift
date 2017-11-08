//
//  ViewController.swift
//  PropertyFinder
//
//  Created by Admin on 8/11/17.
//  Copyright © 2017 Krys. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    
    var page = 0
    var order = "pa"
    let urlString = "https://www.propertyfinder.ae/mobileapi"
    
    var titleArray = [String]()
    var priceArray = [String]()
    var bedsArray = [String]()
    var imgURLArray = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.downPFList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downPFList(){
        var furl = urlString
        furl.append("?page=")
        furl.append(String(page))
        furl.append("&order=")
        furl.append(order)
        let url = NSURL(string: furl)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler:{(data, response, error) -> Void in
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                if let resArray = json!.value(forKey: "res") as? NSArray {
                    for res in resArray {
                        if let resDict = res as? NSDictionary {
                            if let title = resDict.value(forKey: "title"){
                                self.titleArray.append(title as! String)
                            }
                            if let price = resDict.value(forKey: "price"){
                                self.priceArray.append(price as! String)
                            }
                            if let beds = resDict.value(forKey: "bedrooms"){
                                self.bedsArray.append(String(describing: beds))
                            }
                            if let img = resDict.value(forKey: "thumbnail"){
                                self.imgURLArray.append(img as! String)
                            }
                            
                            OperationQueue.main.addOperation {
                                self.tableView.reloadData()
                            }
                        }
                    }	
                }
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.TitleLabel.text = titleArray[indexPath.row]
        cell.PriceLabel.text = priceArray[indexPath.row]
        cell.BedsLabel.text = bedsArray[indexPath.row] + " bedrooms"
        
        let imgURL = NSURL(string: imgURLArray[indexPath.row])
        if imgURL != nil{
            let data = NSData(contentsOf: (imgURL as? URL)!)
            cell.imgV.image = UIImage(data: data as! Data)
        }
        
        let lastItem = titleArray.count - 5
        if indexPath.row == lastItem{
            page = page+1
            self.downPFList()
        }
        
        return cell
    }
}
