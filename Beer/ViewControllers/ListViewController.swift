//
//  ListViewController.swift
//  Beer
//
//  Created by Jef Braem on 07/08/2018.
//  Copyright © 2018 Jef Braem. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var beersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        beersTableView.dataSource = self
        beersTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! BeerCell
        cell.LeftCell.text = "Hoegaarden"
        cell.RightCell.text = "4/5"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

class ToDo: Object {
    dynamic var Name = ""
    dynamic var Score = 0
}

class BeerCell: UITableViewCell {
    @IBOutlet weak var LeftCell: UILabel!
    @IBOutlet weak var RightCell: UILabel!
}
