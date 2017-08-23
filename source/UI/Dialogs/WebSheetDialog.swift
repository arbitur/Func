//
//  WebSheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 28/Apr/17.
//
//

import UIKit
import WebKit





/// If no actions will add a generic cancel action
public final class WebSheetDialog: SheetDialog, WKNavigationDelegate {
	public let webView = WKWebView()
	var activityIndicator: UIActivityIndicatorView?
	
	
	
	public override func viewDidLoad() {
		activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		activityIndicator!.color = .gray
		activityIndicator!.hidesWhenStopped = false
		activityIndicator!.startAnimating()
		webView.add(view: activityIndicator!) {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
		}
		
		webView.navigationDelegate = self
		
		if actions.isEmpty {
			self.addCancel(title: "Stäng")
		}
		
		super.viewDidLoad()
		
		webView.lac.height.equal(to: self.view.lac.height, priority: 500)
	}
	
	
	public convenience init(title: String? = nil, subtitle: String? = nil, html: String) {
		self.init(title: title, subtitle: subtitle)
		webView.loadHTMLString(html, baseURL: nil)
	}
	
	public convenience init(title: String? = nil, subtitle: String? = nil, url: URL) {
		self.init(title: title, subtitle: subtitle)
		webView.load(URLRequest(url: url))
	}
	
	public required init(title: String?, subtitle: String?) {
		super.init(title: title, subtitle: subtitle)
		customViews.append(webView)
	}
	
	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
	public required init?(coder aDecoder: NSCoder) { fatalError() }
	
	
	
	public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		UIView.animate(withDuration: 0.2) {
			self.activityIndicator?.transform(scale: 0.1)
			self.activityIndicator?.layoutIfNeeded()
		}
	}
	
	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicator?.stopAnimating()
		activityIndicator?.removeFromSuperview()
	}
	
	public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		didFail(error: error)
	}
	
	public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		didFail(error: error)
	}
	
	private func didFail(error: Error) {
		activityIndicator?.transform(scale: 1)
		activityIndicator?.color = .red
		activityIndicator?.stopAnimating()
		
		let label = UILabel(font: .systemFont(ofSize: 17), color: .black, alignment: .center, lines: 0)
		label.text = error.localizedDescription
		
		webView.add(view: label) {
			$0.top.equal(to: activityIndicator!.lac.centerY, constant: 16)
			$0.left.equalToSuperview(16)
			$0.right.equalToSuperview(-16)
			$0.centerX.equalToSuperview()
		}
	}
}










