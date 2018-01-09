//
//  ViewController.swift
//  Test
//
//  Created by Philip Fryklund on 27/9/16.
//  Copyright © 2016 Philip Fryklund. All rights reserved.
//

import Foundation





open class SlideTabController: UIViewController {
	fileprivate let scrollView = ScrollView()
	private let menu = Menu()
	
	public var selectedIndex: Int { return menu.index }
	
	public var selectedViewController: UIViewController? {
		return self.childViewControllers[safe: menu.index]
	}
	open override var childViewControllerForStatusBarHidden: UIViewController? {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: .UIApplicationDidChangeStatusBarFrame, object: nil)
		}
		
		return self.selectedViewController
	}
	open override var childViewControllerForStatusBarStyle: UIViewController? {
		return self.selectedViewController
	}
	
	
	
//	func selectViewController(index: Int) {
//		menu.selectViewController(index: index)
//	}
	
	
	private func showViewController(_ vc: UIViewController) {
		if !vc.isViewLoaded {
			vc.loadViewIfNeeded()
			
			self.scrollView.addSubview(vc.view)
			
			vc.view.frame.size = scrollView.bounds.size
			vc.view.layoutIfNeeded()
			
			vc.didMove(toParentViewController: self)
		}
	}
	
	
	public func load(viewControllers: [UIViewController]) {
		if !viewControllers.isEmpty {
			self.loadViewIfNeeded()
			
			for vc in viewControllers {
				self.addChildViewController(vc)
				scrollView.stackView.addArrangedSubview(vc.view)
				menu.addTab(title: vc.title ?? "Title")
				
				vc.view.lac.width.equalTo(self.view.lac.width)
			}
			
//			selectViewController(index: 0)
			menu.index = 0
			showViewController(self.childViewControllers.first!)
		}
	}
	
	public var initialIndex: Int?
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
//		print(scrollView.frame, scrollView.contentSize)
		
		if scrollView.contentSize != CGSize.zero, let index = initialIndex {
			initialIndex = nil
			
			let x = CGFloat(index) * scrollView.bounds.width
			scrollView.contentOffset.x = x
			menu.index = index
		}
	}
	
	open override func loadView() {
		self.view = UIView(backgroundColor: .white)
		
		self.view.add(views: menu, scrollView)
		
		menu.lac.make {
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			
			switch SlideTabAppearance.align {
				case .top: $0.top.equalTo(self.topLayoutGuide.lac.bottom)
				case .bottom: $0.bottom.equalTo(self.bottomLayoutGuide.lac.top)
			}
		}
		
		scrollView.lac.make {
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			
			switch SlideTabAppearance.align {
				case .top:
					$0.top.equalTo(menu.lac.bottom)
					$0.bottom.equalToSuperview()
				case .bottom:
					$0.top.equalToSuperview()
					$0.bottom.equalTo(menu.lac.top)
			}
		}
	}
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
		
		
	}
	
	public convenience init(viewControllers: [UIViewController]) {
		self.init(nibName: nil, bundle: nil)
		load(viewControllers: viewControllers)
	}
}
	
extension SlideTabController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let fullWidth = scrollView.contentSize.width
		let leftPosition = scrollView.contentOffset.x
		let rightPosition = scrollView.contentOffset.x + scrollView.bounds.width
		
//		let index = Int((rightPosition - 1) / scrollView.bounds.width)
////		print(index)
//
//		if let vc = self.childViewControllers[safe: index] {
//			showViewController(vc)
//		}
		
//		print("Left: \(leftPosition / fullWidth)%", "Right: \(rightPosition / fullWidth)%")
		
		menu.indicator.frame.left = menu.contentSize.width * (leftPosition / fullWidth)
		menu.indicator.frame.widt = menu.contentSize.width * ((rightPosition - leftPosition) / fullWidth)
		
		//TODO: Right edge not flush
		if scrollView.contentSize.width > scrollView.bounds.width {
			let offset = menu.contentOffset.x
			let width = menu.bounds.width
			let left = menu.indicator.frame.left
			let right = menu.indicator.frame.right
			let maxOffset = menu.contentSize.width - width
			
			let limitOffset: CGFloat = width * 0.2
			let leftLimit = offset + limitOffset
			let rightLimit = offset + width - limitOffset
			
			
			if offset > 0 && left < leftLimit {
				let distance = leftLimit - left
				menu.contentOffset.x = max(0, offset - distance)
				
			}
			else if offset < maxOffset && right > rightLimit {
				let distance = right - rightLimit
				menu.contentOffset.x = min(maxOffset, offset + distance)
			}
		}
	}
	
	
	public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		scrollView.isUserInteractionEnabled = false
	}
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		scrollView.isUserInteractionEnabled = true
		
		let index = (scrollView.contentOffset.x + scrollView.bounds.width) / scrollView.bounds.width
		menu.index = Int(index) - 1
	}
}


//extension SlideTabController: RootViewControllable {
//
//	public var viewForEdgePanGestureRecognizer: UIView {
//		return self.scrollView
//	}
//}




private class ScrollView: UIScrollView {
	var tabController: SlideTabController { return self.superViewController as! SlideTabController }
	let stackView = UIStackView()
	
	
	
//	private override func layoutSubviews() {
//		super.layoutSubviews()
//
//		self.contentSize.height = self.bounds.height
//		self.contentSize.width = self.bounds.width * CGFloat(tabController.childViewControllers.count)
//
//		for (i, vc) in tabController.childViewControllers.enumerated() {
//			if let view = vc.viewIfLoaded {
//				view.frame.size = self.bounds.size
//				view.frame.left = self.bounds.width * CGFloat(i)
//			}
//		}
//	}
	
	convenience init() {
		self.init(frame: CGRect.zero)
		
		self.showsHorizontalScrollIndicator = false
		
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		self.addSubview(stackView)
		
		stackView.lac.make {
			$0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
			$0.height.equalToSuperview()
		}
	}
}






















public class SlideTabAppearance {
	public static var backgroundColor: UIColor = .white
	public static var indicatorColor: UIColor = .orange
	public static var tabDeselectedTitleColor: UIColor = .lightGray
	public static var tabSelectedTitleColor: UIColor = .darkGray
	public static var tabTitleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
	public static var indicatorHeight: CGFloat = 2
	public static var indicatorMinimumWidth: CGFloat = 95
	public static var align: MenuAlign = .top
}




public enum MenuAlign {
	case top, bottom
}



protocol MenuDelegate {
	func selected(vc: UIViewController)
}


	
private class Menu: UIScrollView {
	let stackView = StackView()
	var indicator: UIView { return stackView.indicator }
	var index: Int = 0 {
		willSet {
			let button = stackView.arrangedSubviews[index] as! UIButton
			button.tintColor = SlideTabAppearance.tabDeselectedTitleColor
		}
		didSet {
			let button = stackView.arrangedSubviews[index] as! UIButton
			button.tintColor = SlideTabAppearance.tabSelectedTitleColor
			self.superViewController?.setNeedsStatusBarAppearanceUpdate()
			
			
		}
	}
	
	
	
	func selectViewController(index: Int) {
		self.index = index
		
		let tc = self.superViewController as! SlideTabController
		
		let offset = CGPoint(tc.scrollView.bounds.width * CGFloat(index), tc.scrollView.contentOffset.y)
		tc.scrollView.setContentOffset(offset, animated: true)
	}
	
	
	@objc func press(button: UIButton) {
		selectViewController(index: button.tag)
	}
	
	
	func addTab(title: String) {
		let btn = UIButton(type: .system)
		btn.titleLabel!.font = SlideTabAppearance.tabTitleFont
		btn.tintColor = SlideTabAppearance.tabDeselectedTitleColor
		btn.setTitle(title, for: .normal)
		btn.tag = stackView.arrangedSubviews.count
		btn.addTarget(self, action: #selector(press(button:)), for: .touchUpInside)
		stackView.addArrangedSubview(btn)
		
		btn.lac.make {
			$0.width.greaterThan(SlideTabAppearance.indicatorMinimumWidth)
			$0.width.lessThan(self.lac.width, multiplier: 0.6)
		}
	}
	
	
	private var heightConstraint: NSLayoutConstraint?
	private var topConstraint: NSLayoutConstraint?
	@objc func didChangeStatusBar(_ notification: Notification) {
		var vc: UIViewController? = self.superViewController
		while(vc != nil) {
			if let nc = vc as? UINavigationController, !nc.isNavigationBarHidden { return }
			vc = vc?.parent
		}
		
		let height = UIApplication.shared.statusBarFrame.height
		
		heightConstraint?.constant = 44 + height
		topConstraint?.constant = height
	}
	
	
	convenience init() {
		self.init(frame: CGRect.zero)
		
		self.bounces = false
		self.showsHorizontalScrollIndicator = false
		self.backgroundColor = SlideTabAppearance.backgroundColor
		
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		stackView.spacing = 10
		
		self.addSubview(stackView)
		
		heightConstraint = self.lac.height.equalTo(44)
		
		stackView.lac.make {
			topConstraint = $0.top.equalToSuperview()
			$0.left.equalToSuperview()
			$0.right.equalToSuperview()
			$0.bottom.equalToSuperview()
			$0.width.greaterThan(self.lac.width)
			$0.height.equalTo(44)
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(didChangeStatusBar(_:)), name: .UIApplicationDidChangeStatusBarFrame, object: nil)
	}
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	
	
	class StackView: UIStackView {
		let indicator = UIView(backgroundColor: SlideTabAppearance.indicatorColor)
		override func layoutSubviews() {
			super.layoutSubviews()
			
			indicator.frame.bottom = self.bounds.height
			
			if let btn = self.arrangedSubviews[safe: 0] {
				indicator.frame.widt = btn.bounds.width
			}
		}
		convenience init() {
			self.init(frame: CGRect.zero)
			
			indicator.frame.heigt = SlideTabAppearance.indicatorHeight
			
			self.addSubview(indicator)
		}
	}
}




















