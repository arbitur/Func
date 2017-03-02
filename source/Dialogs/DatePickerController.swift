//
//  DatePickerController.swift
//  TidyClient
//
//  Created by Philip Fryklund on 10/Feb/17.
//  Copyright © 2017 Philip Fryklund. All rights reserved.
//

import SnapKit






class DatePickerController: UIViewController {
	private let blurView1 = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	private let blurView2 = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	private let stackView = UIStackView()
	private var constraint: Constraint!
	
	let datePicker = UIDatePicker()
	private let message: String?
	private let cancel: String
	private let action: (Date)->()
	
	
	
	
	
	func dismissDatePicker() {
		action(datePicker.date)
		self.dismiss(animated: true, completion: nil)
	}
	
	
	
	private func loadContent() {
		let stack = UIStackView(axis: .vertical)
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
		
		stackView.addArrangedSubview(datePicker)
		
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
	
	
	
	
	
	init(title: String?, message: String?, cancel: String, completion: @escaping (Date)->()) {
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




















