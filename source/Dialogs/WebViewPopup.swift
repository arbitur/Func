
import WebKit
import SnapKit





@available(*, deprecated)
public class WebViewPopup: UIViewController {
	private let contentView = UIView(backgroundColor: UIColor.white.alpha(0.5))
	private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	private let stackView = UIStackView()
	
	private var message: String?
	private let webView = WKWebView()
	private var url: URL!
	
	public var tintColor: UIColor = UIColor(hex: 0x0E7AfE)
	
	
	
	func dismissPopup() {
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
		
		webView.backgroundColor = .clear
		webView.scrollView.backgroundColor = .clear
		stackView.addArrangedSubview(webView)
	}
	
	
	public override func loadView() {
		self.view = UIView(backgroundColor: UIColor.black.alpha(0.4))
	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		contentView.cornerRadius = 14
		self.view.addSubview(contentView)
		contentView.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.size.equalToSuperview().multipliedBy(0.9)
		}
		
		contentView.addSubview(blurView)
		blurView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		blurView.contentView.addSubview(stackView)
		
		stackView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		
		loadContent()
		
		let dismissButton = UIButton(type: UIButtonType.contactAdd)
		dismissButton.tintColor = self.tintColor
		dismissButton.transform(rotation: CGFloat.pi / 4)
		dismissButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
		contentView.addSubview(dismissButton)
		
		dismissButton.snp.makeConstraints {
			$0.top.equalToSuperview().offset(4)
			$0.right.equalToSuperview().offset(-4)
		}
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if animated {
			contentView.transform(scale: 1.2)
			contentView.transform(scale: 1.0)
		}
		
		webView.load(URLRequest(url: url))
	}
	public override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		webView.stopLoading()
	}
	
	public convenience init(title: String?, message: String?, url: URL) {
		self.init(nibName: nil, bundle: nil)
		
		self.modalPresentationStyle = .overCurrentContext
		self.modalTransitionStyle = .crossDissolve
		
		self.title = title
		self.message = message
		
		print("Popup", url)
		self.url = url
	}
	
	deinit {
		webView.stopLoading()
		print("Deinit", type(of: self))
	}
}





















