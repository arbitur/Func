
import SnapKit





@available(*, deprecated)
public class AlertController: UIViewController {
	private let contentView = UIView(backgroundColor: UIColor.white.alpha(0.5))
	private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
	private let stackView = UIStackView()
	
	private var message: String?
	private var customView: UIView?
	var buttons: [Button]
	
	
	
	
	
	public func dismissAlert(_ button: Button) {
		self.dismiss(animated: true, completion: {
			button.action?()
		})
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
		
		if let view = self.customView {
			stackView.addArrangedSubview(view)
		}
	}
	
	private func loadButtons() {
		let buttonContainer = UIStackView()
		buttonContainer.axis = .vertical
		
		let border = UIView(backgroundColor: .lightGray)
		buttonContainer.addArrangedSubview(border)
		border.snp.makeConstraints {
			$0.height.equalTo(points(pixels: 1))
		}
		
		let buttonStack = UIStackView()
		buttonStack.axis = self.buttons.count >= 3 ? .vertical : .horizontal
		for (i, button) in self.buttons.enumerated() {
			if i != 0 {
				let border = UIView(backgroundColor: .lightGray)
				buttonStack.addArrangedSubview(border)
				border.snp.makeConstraints {
					(buttonStack.axis == .vertical ? $0.height : $0.width).equalTo(points(pixels: 1))
				}
			}
			
			button.addTarget(self, action: #selector(dismissAlert(_:)), for: .touchUpInside)
			buttonStack.addArrangedSubview(button)
			
			if let last = self.buttons[safe: i-1] {
				button.snp.makeConstraints {
					$0.width.equalTo(last.snp.width)
				}
			}
		}
		
		buttonContainer.addArrangedSubview(buttonStack)
		
		stackView.addArrangedSubview(buttonContainer)
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
			$0.width.equalTo(270)
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
		loadButtons()
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if animated {
			contentView.transform(scale: 1.2)
			self.view.layoutIfNeeded()

			UIView.animate(
				withDuration: 0.2,
				delay: 0,
				options: [UIViewAnimationOptions.curveEaseIn],
				animations: {
					self.contentView.transform(scale: 1.0)
				},
				completion: nil)
		}
	}
	

	public init(title: String?, message: String?, view: UIView? = nil, buttons: [Button]) {
		self.message = message
		self.customView = view
		self.buttons = buttons
		
		super.init(nibName: nil, bundle: nil)
		
		self.modalPresentationStyle = .overCurrentContext
		self.modalTransitionStyle = .crossDissolve
		
		self.title = title
	}
	
	
	
	public convenience init(title: String?, message: String?, view: UIView? = nil, dismiss: String = "OK", action: Closure? = nil) {
		let button = Button(title: dismiss, type: .cancel, action: action)
		self.init(title: title, message: message, view: view, buttons: [button])
	}
	
//	convenience init(title: String?, message: String?, view: UIView? = nil) {
//		self.init(title: title, message: message, view: view, buttons: [])
//	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
	
	
	public class Button: UIButton {
		fileprivate var action: Closure?
		
		
		public convenience init(title: String, type: Type, action: Closure?) {
			self.init(frame: .zero)
			
			self.action = action
			
			self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: type == .cancel ? UIFontWeightSemibold : UIFontWeightRegular)
			self.setTitle(title, for: .normal)
			self.setTitleColor(type.color(), for: .normal)
			
			self.snp.makeConstraints {
				$0.height.equalTo(44)
			}
		}
		
		
		public enum `Type` {
			case `default`
			case cancel
			case destructive
			
			func color() -> UIColor {
				switch self {
					case .cancel:       return UIColor(hex: 0x006ADE)
					case .destructive:  return UIColor.red.lightened(by: 0.2)
					default:            return UIColor(hex: 0x007AFF)
				}
			}
		}
	}
}























