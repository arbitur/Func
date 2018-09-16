//
//  ScrollStackView.swift
//  Pods
//
//  Created by Philip Fryklund on 27/Apr/17.
//
//

import UIKit





open class ScrollStackView: UIScrollView {
	
	public let contentStack: UIStackView = UIStackView()
	open var axis: UILayoutConstraintAxis {
		get { return contentStack.axis }
		set {
			contentStack.axis = newValue
			switch newValue {
				case .horizontal: widthConstraint.deactivate() ; heightConstraint.activate()
				case .vertical: widthConstraint.activate() ; heightConstraint.deactivate()
			}
		}
	}
	
	private var widthConstraint: NSLayoutConstraint!
	private var heightConstraint: NSLayoutConstraint!
	
	private func initz() {
		self.addSubview(contentStack)
		
		self.add(view: contentStack) {
			$0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
			
			widthConstraint =  $0.width.equalToSuperview()
			heightConstraint =  $0.height.equalToSuperview()
		}
		axis = contentStack.axis
	}
	
	public init(axis: UILayoutConstraintAxis) {
		super.init(frame: .zero)
		initz()
		self.axis = axis
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		initz()
		self.axis = .vertical
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initz()
		self.axis = .vertical
	}
}












