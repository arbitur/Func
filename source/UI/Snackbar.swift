//
//  Snackbar.swift
//  Pods
//
//  Created by Philip Fryklund on 18/Aug/17.
//
//

import UIKit





@available(*, deprecated, message: "Maybe discontinued")
public struct Snackbar {
	
	public enum Duration {
		case short, long, infinite, custom(Float)
		
		fileprivate var rawValue: Float {
			switch self {
			case .short: return 2.5
			case .long: return 5
			case .custom(let d): return d
			default: return 0
			}
		}
	}
	
	fileprivate let text: String
	fileprivate let duration: Duration
	
	
	
//	public init(text: String, duration: Duration = .short) {
//		self.text = text
//		self.duration = duration
//	}
}





@available(*, deprecated, message: "Maybe discontinued")
fileprivate class SnackbarView: UIView {
	let label: UILabel
	let snackbar: Snackbar
	let id: UInt
	
	var startDate: Date!
	var endDate: Date!
	
//	let action: ?
	
	
	init(snackbar: Snackbar, id: UInt, width: CGFloat) {
		self.snackbar = snackbar
		self.id = id
		
		let padding = UIEdgeInsets(horizontal: 24, vertical: 16)
		
		label = UILabel()
		label.text = snackbar.text
		label.frame.size = label.sizeThatFits( CGSize( width - padding.totalWidth, .max ) )
		label.frame.origin = CGPoint( padding.left, padding.top )
		
		let frame = CGRect(size: CGSize( width, label.frame.bottom + padding.bottom ) )
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}





@available(*, deprecated, message: "Maybe discontinued")
private class SnackbarHandler {
	static let shared = SnackbarHandler()
	
	var numberOfSnackbars: UInt = 0
	var runningSnackbars: [Int: SnackbarView] = [:]
	
	
	var window: UIWindow {
		return UIWindow.current!
	}
	
	lazy var snackbarContainer: UIView = {
		let view = UIView()
		view.frame.widt = self.window.bounds.width
		return view
	}()
	
	
	
	func present(snackbar: Snackbar) {
		let view = SnackbarView(snackbar: snackbar, id: numberOfSnackbars, width: window.bounds.width)
		view.startDate = Date()
		view.endDate = view.startDate + .milliseconds( Int(snackbar.duration.rawValue * 1000) )
		
		//Give up
		
		numberOfSnackbars += 1
	}
	
	@objc func dismiss(_ notification: Notification) {
		
	}
}


extension Notification.Name {
	@available(*, deprecated, message: "Maybe discontinued")
	static let snackbarDismiss = Notification.Name(rawValue: "asdasd")
}



























