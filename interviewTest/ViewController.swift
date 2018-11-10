//
//  ViewController.swift
//  interviewTest
//
//  Created by tax_k on 10/11/2018.
//  Copyright © 2018 tax_k. All rights reserved.
//

import UIKit

struct Issue {
    let number: Int
    let title: String
    
    init(json: [String: Any]) {
        number =  json["number"] as! Int
        title = json["title"] as! String
    }
}

class ViewController: UIViewController{

    let hReq:httpRequest = httpRequest()
    var resultArray = [[String: Any]]()
    var urlArr = [String]()
    
    var urlScheme: String = ""
    var schemeArr = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            urlScheme = appDelegate.customUrl
            
//            print(urlScheme)
            
            let trimmedString = urlScheme.replacingOccurrences(of: "\\s?\\{[\\w\\s]*\\}", with: "", options: .regularExpression)
            
            urlScheme = urlScheme.replacingOccurrences(of: "%7D", with: "/", options: NSString.CompareOptions.literal, range: nil)
            urlScheme = urlScheme.replacingOccurrences(of: "%7B", with: "/", options: NSString.CompareOptions.literal, range: nil)
            
            if urlScheme.count > 0 {
                schemeArr = urlScheme.components(separatedBy: "///")
                
                getData(schemeArr[1], schemeArr[2])
            }else {
                getData("firebase", "firebase-ios-sdk/")
            }
            
            print(schemeArr)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(_ org:String , _ repo:String) {
        
        let getUrl = "https://api.github.com/repos/"+org+"/"+repo+"issues"
        
        urlArr =  getUrl.components(separatedBy: "/")
        
        guard let url = URL(string: getUrl) else { return }
        URLSession.shared.dataTask(with: url){ (data, response, err) in
            guard let data = data else { return }
            
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else { return }
                print(type(of: json))
                
                self.resultArray = json
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch let jsonErr {
                print(jsonErr)
            }
            
        }.resume()
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell
            cell.textLabel?.text = urlArr[4]+"/"+urlArr[5]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            
            return cell
        case 2:
            let cell = Bundle.main.loadNibNamed("DummyTableViewCell", owner: self, options: nil)?.first as! DummyTableViewCell
            let imgUrl:String = ""
            
            cell.logoImageView.setImageFromURl(stringImageUrl: imgUrl)
            //??
            cell.logoImageView.image = UIImage(named: "main_logo.png")
//            cell.logoImageView.contentMode = .
            
            return cell
            
        default:
            let cell = Bundle.main.loadNibNamed("ResultTableViewCell", owner: self, options: nil)?.first as! ResultTableViewCell
            
            let title:String = resultArray[indexPath.row]["title"] as! String
            let number:Int = resultArray[indexPath.row]["number"] as! Int
            
            cell.textLabel?.text = "#"+String(number)+" : "+title
            cell.textLabel?.numberOfLines = 0
            
            return cell
        }
        
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 40
        case 2:
            return 100
        default:
            return UITableViewAutomaticDimension
        }
    }
}
