//
//  WebSheetDialog.swift
//  Pods
//
//  Created by Philip Fryklund on 28/Apr/17.
//
//

import UIKit
import WebKit

public typealias WebSheetDialog = WebSheetDialogController // For backwards compatibility

/// If no actions will add a generic cancel action
public final class WebSheetDialogController: SheetDialogController {
	
	public let webView = WKWebView()
	var activityIndicator: UIActivityIndicatorView?
	
	
	public override func loadView() {
		if actions.isEmpty {
			self.addCancel(title: "Stäng")
		}
		
		super.loadView()
		
		webView.lac.height.equalTo(self.view.lac.height, priority: 500.0)
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
		
		activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
		activityIndicator!.color = .gray
		activityIndicator!.hidesWhenStopped = false
		activityIndicator!.startAnimating()
		webView.add(view: activityIndicator!) {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
		}
		
		webView.navigationDelegate = self
		
		addCustomView(webView)
	}
	
	public override init(nibName: String?, bundle: Bundle?) { fatalError() }
	public required init?(coder aDecoder: NSCoder) { fatalError() }
}


extension WebSheetDialog: WKNavigationDelegate {
	
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
			if let activityIndicator = activityIndicator {
				$0.top.equalTo(activityIndicator.lac.bottom, constant: 16)
			}
			else {
				$0.centerY.equalToSuperview()
			}
			$0.horizontalEdges.equalToSuperview(UIEdgeInsets(inset: 16))
		}
	}
}
