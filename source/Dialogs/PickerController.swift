//
//  DatePickerController.swift
//  TidyClient
//
//  Created by Philip Fryklund on 10/Feb/17.
//  Copyright © 2017 Philip Fryklund. All rights reserved.
//

import SnapKit





class PickerController: UIViewController {
//	private let contentView = UIView()//color: UIColor.white.alpha(0.5))
	private let blurView1 = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	private let blurView2 = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	private let stackView = UIStackView()
	private var constraint: Constraint!
	
	let pickerView = UIPickerView()
	private let message: String?
	private let cancel: String
	fileprivate let rows: [String]
	private let action: (Int)->()
	
	
	
	
	
	func dismissDatePicker() {
		action(pickerView.selectedRow(inComponent: 0))
		self.dismiss(animated: true, completion: nil)
	}
	
	
	let stack = UIStackView(axis: .vertical)
	let infoStack = StackView(axis: .vertical)
	
	private func loadContent() {
		stack.spacing = 10
		stack.isLayoutMarginsRelativeArrangement = true
		stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		stackView.addArrangedSubview(stack)
		
		if let title = self.title {
			let label = UILabel(font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold), alignment: .center)
			label.numberOfLines = 0
			label.text = title
			stack.addArrangedSubview(label)
		}
		
		if let message = self.message {
			let label = UILabel(font: UIFont.systemFont(ofSize: 13), alignment: .center)
			label.numberOfLines = 0
			label.text = message
			stack.addArrangedSubview(label)
		}
		
		let border = UIView(backgroundColor: .lightGray)
		pickerView.addSubview(border)
		border.snp.makeConstraints {
			$0.left.top.right.equalToSuperview()
			$0.height.equalTo(points(pixels: 1))
		}
		
		pickerView.setContentCompressionResistancePriority(1, for: .vertical)
		pickerView.delegate = self
		pickerView.dataSource = self
		stackView.addArrangedSubview(pickerView)
//		pickerView.snp.makeConstraints {
//			$0.height.equalTo(120)
//		}
		
		let cancelButton = UIButton(type: .system)
		cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
		cancelButton.setTitle(cancel, for: .normal)
		cancelButton.setTitleColor(UIColor(hex: 0x006ADE), for: .normal)
		cancelButton.addTarget(self, action: #selector(dismissDatePicker), for: .touchUpInside)
		blurView2.addSubview(cancelButton)
		
		cancelButton.snp.makeConstraints {
			$0.edges.equalToSuperview()
			$0.height.equalTo(44)
		}
	}
	
	
	
	var shouldAnimatePicker = true
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if shouldAnimatePicker && self.view.frame.size != .zero {
			shouldAnimatePicker = false
			
			UIView.animate(withDuration: 0.4, animations: {
				self.constraint.deactivate()
				self.view.layoutIfNeeded()
			})
		}
	}
	
	override func loadView() {
		self.view = UIView(backgroundColor: UIColor.black.alpha(0.4))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		self.view.addSubview(blurView1)
		blurView1.snp.makeConstraints {
			constraint = $0.top.equalTo(self.view.snp.bottom).constraint
			$0.top.greaterThanOrEqualToSuperview().offset(20)
			$0.centerX.equalToSuperview()
		}
		
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		blurView1.contentView.addSubview(stackView)
		stackView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		
		self.view.addSubview(blurView2)
		blurView2.snp.makeConstraints {
			$0.top.equalTo(blurView1.snp.bottom).offset(16).priority(750)
			$0.bottom.equalToSuperview().offset(-16)
			$0.left.right.equalTo(blurView1)
			$0.centerX.equalToSuperview()
		}

		if UIScreen.main.screenSize ?== [.inch4_7, .inch5_5] {
			blurView1.cornerRadius = 5
			blurView2.cornerRadius = 5
		}
		
		loadContent()
		
		self.view.layoutIfNeeded()
	}
	
	
	
	
	
	init(title: String?, message: String?, cancel: String, rows: [String], completion: @escaping (Int)->()) {
		self.rows = rows
		self.message = message
		self.cancel = cancel
		self.action = completion
		
		super.init(nibName: nil, bundle: nil)
		
		self.modalPresentationStyle = .overCurrentContext
		self.modalTransitionStyle = .crossDissolve
		
		self.title = title
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}



extension PickerController: UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return rows.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return rows[row]
	}
}




















