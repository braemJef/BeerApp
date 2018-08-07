//
//  ListViewController.swift
//  Beer
//
//  Created by Jef Braem on 07/08/2018.
//  Copyright © 2018 Jef Braem. All rights reserved.
//

import UIKit
import RealmSwift

var beers: Results<Beer>!
var realm = try! Realm()

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var beersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        beers = realm.objects(Beer.self)
        beersTableView.dataSource = self
        beersTableView.delegate = self
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! BeerCell
        let todo = beers[indexPath.row]
        cell.LeftCell.text = todo.Name
        cell.RightCell.text = todo.Brewery
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func reload() {
        beersTableView.reloadData()
    }
}

class Beer: Object {
    @objc dynamic var Name = ""
    @objc dynamic var Brewery = ""
}

class BeerCell: UITableViewCell {
    @IBOutlet weak var LeftCell: UILabel!
    @IBOutlet weak var RightCell: UILabel!
}


