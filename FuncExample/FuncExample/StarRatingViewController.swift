//
//  File.swift
//  FuncExample
//
//  Created by Philip Fryklund on 8/Dec/17.
//  Copyright © 2017 Arbitur. All rights reserved.
//

import Func





class StarRatingViewController: UIViewController {
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var starView: StarRatingView!
	
	private var testCase: Int = -1 {
		didSet {
			titleLabel.text = String(testCase)
		}
	}
	
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		testCase += 1
		
		switch testCase {
		case 0:
			starView.value = Random.range(min: 0, max: Float(starView.numberOfStars))
		case 1:
			starView.numberOfStars = Random.range(3..<10)
		case 2:
			let character: Character = Random.flipCoin() ? "\u{2605}" : "\u{2726}"
			let size: CGFloat = Random.range(min: 20, max: 50)
			starView.starSource = .character(character, size)
		case 3:
			starView.backgroundColor = .random
		case 4:
			starView.tintColor = .random
		default:
			testCase = -1
			return touchesEnded(touches, with: event)
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		starView.isEnabled = true
	}
}
