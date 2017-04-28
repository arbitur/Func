//
//  ScrollStackView.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Apr/17.
//
//

import UIKit





open class ScrollStackView: UIScrollView {
	public let contentStack: UIStackView
	
	private func setup() {
		self.addSubview(contentStack)
		
		self.add(view: contentStack) {
			$0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
			
			switch contentStack.axis {
				case .horizontal: $0.height.equalToSuperview()
				case .vertical	: $0.width.equalToSuperview()
			}
		}
	}
	
	public init(axis: UILayoutConstraintAxis) {
		contentStack = UIStackView(axis: axis)
		super.init(frame: .zero)
		setup()
	}
	
	public override init(frame: CGRect) {
		contentStack = UIStackView(axis: .vertical)
		super.init(frame: frame)
		setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		contentStack = UIStackView(axis: .vertical)
		super.init(coder: aDecoder)
		setup()
	}
}












