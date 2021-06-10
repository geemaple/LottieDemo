//
//  JsonExplorerViewController.swift
//  Lottie_demo
//
//  Created by jixiangfeng on 2021/6/10.
//

import UIKit

class JsonExplorerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView(frame: .zero, style: .plain)
    let dataSource = JsonFileDataProvider.dataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupLayouts()
    }
    
    func setupViews() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        self.view.addSubview(tableView)
    }
    
    func setupLayouts() -> Void {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let filePath = self.dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
