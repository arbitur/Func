//
//  TableViewController
//  FuncExample
//
//  Created by Philip Fryklund on 28/Feb/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import UIKit
import Func





class TableViewController: UIViewController {
	typealias Examples = [(title: String, action: Closure)]
	let tableView = UITableView()
	var examples: Examples {
		return []
	}
	
	
	override func loadView() {
		self.view = tableView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .white
		
		tableView.dataSource = self
		tableView.delegate = self
	}
	
}

extension TableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let action = examples[indexPath.row].action
		action()
	}
}

extension TableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return examples.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.cell(for: "cell") ?? UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
		cell.textLabel?.text = examples[indexPath.row].title
		return cell
	}
}
















