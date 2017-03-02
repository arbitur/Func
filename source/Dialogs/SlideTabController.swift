//
//  ViewController.swift
//  Test
//
//  Created by Philip Fryklund on 27/9/16.
//  Copyright © 2016 Philip Fryklund. All rights reserved.
//

import SnapKit





open class SlideTabController: UIViewController {
	fileprivate let scrollView = ScrollView()
	fileprivate let menu = Menu()
	
	var selectedIndex: Int { return menu.index }
	
	var selectedViewController: UIViewController? {
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
	
	
	fileprivate func showViewController(_ vc: UIViewController) {
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
//				scrollView.stackView.addArrangedSubview(vc.view)
				menu.addTab(title: vc.title ?? "Title")
				
//				vc.view.snp.makeConstraints {
//					$0.width.equalTo(self.view.snp.width)
//				}
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
		
		menu.snp.makeConstraints {
			$0.left.right.equalToSuperview()
			
			switch SlideTabAppearance.align {
				case .top: $0.top.equalToSuperview()
				case .bottom: $0.bottom.equalToSuperview()
			}
		}
		
		scrollView.snp.makeConstraints {
			$0.left.right.equalToSuperview()
			
			switch SlideTabAppearance.align {
				case .top:
					$0.top.equalTo(menu.snp.bottom)
					$0.bottom.equalToSuperview()
				case .bottom:
					$0.top.equalToSuperview()
					$0.bottom.equalTo(menu.snp.top)
			}
		}
	}
	open override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
		
		
	}
	
	public convenience init(viewControllers: [UIViewController]) {
		self.init()
		load(viewControllers: viewControllers)
	}
}
	
extension SlideTabController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let fullWidth = scrollView.contentSize.width
		let leftPosition = scrollView.contentOffset.x
		let rightPosition = scrollView.contentOffset.x + scrollView.bounds.width
		
		let index = Int((rightPosition - 1) / scrollView.bounds.width)
//		print(index)
		
		if let vc = self.childViewControllers[safe: index] {
			showViewController(vc)
		}
		
//		print("Left: \(leftPosition / fullWidth)%", "Right: \(rightPosition / fullWidth)%")
		
		menu.indicator.frame.left = menu.contentSize.width * (leftPosition / fullWidth)
		menu.indicator.frame.w = menu.contentSize.width * ((rightPosition - leftPosition) / fullWidth)
		
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




fileprivate class ScrollView: UIScrollView {
	var tabController: SlideTabController { return self.superViewController as! SlideTabController }
//	let stackView = UIStackView()
	
	
	
	fileprivate override func layoutSubviews() {
		super.layoutSubviews()
		
		self.contentSize.height = self.bounds.height
		self.contentSize.width = self.bounds.width * CGFloat(tabController.childViewControllers.count)
		
		for (i, vc) in tabController.childViewControllers.enumerated() {
			if let view = vc.viewIfLoaded {
				view.frame.size = self.bounds.size
				view.frame.left = self.bounds.width * CGFloat(i)
			}
		}
	}
	
	convenience init() {
		self.init(frame: CGRect.zero)
		
		self.showsHorizontalScrollIndicator = false
		
//		stackView.axis = .horizontal
//		stackView.alignment = .fill
//		stackView.distribution = .fillEqually
//		self.addSubview(stackView)
//		
//		stackView.snp.makeConstraints {
//			$0.edges.equalToSuperview()
//			$0.height.equalToSuperview()
//		}
	}
}






















public class SlideTabAppearance {
	public static var backgroundColor: UIColor = .white
	public static var indicatorColor: UIColor = .orange
	public static var tabDeselectedTitleColor: UIColor = .lightGray
	public static var tabSelectedTitleColor: UIColor = .darkGray
	public static var tabTitleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
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


	
fileprivate class Menu: UIScrollView {
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
	
	
	func press(button: UIButton) {
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
		
		btn.snp.makeConstraints {
			$0.width.greaterThanOrEqualTo(SlideTabAppearance.indicatorMinimumWidth)
			$0.width.lessThanOrEqualTo(self.snp.width).multipliedBy(0.6)
		}
	}
	
	
	func didChangeStatusBar(_ notification: Notification) {
		var vc: UIViewController? = self.superViewController
		while(vc != nil) {
			if let nc = vc as? UINavigationController, !nc.isNavigationBarHidden { return }
			vc = vc?.parent
		}
		
		let height = UIApplication.shared.statusBarFrame.height
		
		self.snp.updateConstraints {
			$0.height.equalTo(44 + height)
		}
		
		self.stackView.snp.updateConstraints {
			$0.top.equalToSuperview().offset(height)
		}
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
		
		self.snp.makeConstraints {
			$0.height.equalTo(44)
		}
		
		stackView.snp.makeConstraints {
			$0.edges.equalToSuperview()
			$0.width.greaterThanOrEqualTo(self.snp.width)
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
				indicator.frame.w = btn.bounds.width
			}
		}
		convenience init() {
			self.init(frame: CGRect.zero)
			
			indicator.frame.h = SlideTabAppearance.indicatorHeight
			
			self.addSubview(indicator)
		}
	}
}




















