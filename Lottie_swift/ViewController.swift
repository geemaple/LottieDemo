//
//  ViewController.swift
//  Lottie_swift
//
//  Created by jixiangfeng on 2021/6/10.
//

import UIKit
import Lottie

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let logo = AnimationView(name: "LottieLogo1")
    let tableView = UITableView(frame: .zero, style: .plain)
    let dataSource = TestCaseDataSourceProvider.dataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupLayouts()
        self.title = "Lottie Test"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logo.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.logo.pause()
    }

    func setupViews() -> Void {
        self.logo.contentMode = .scaleAspectFill
        self.logo.play()
        self.view.addSubview(self.logo)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 50
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        self.view.addSubview(tableView)
    }
    
    func setupLayouts() -> Void {
        self.logo.translatesAutoresizingMaskIntoConstraints = false
        self.logo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.logo.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.logo.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.logo.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.logo.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        let item = self.dataSource[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.row]
        guard let vc = item.className?.init() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

