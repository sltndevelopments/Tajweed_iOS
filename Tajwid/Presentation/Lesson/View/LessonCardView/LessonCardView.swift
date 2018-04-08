//
//  Created by Tagir Nafikov on 10/02/2018.
//

import UIKit
import DTModelStorage
import Globus
import SnapKit


class LessonCardView: UIView, ModelTransfer {
    
    // MARK: - Nested types
    
    private enum Constants {
        static let leading = CGFloat(26)
        static let trailing = CGFloat(25)
        static let top = CGFloat(20)
        static let bottom = CGFloat(20)
        static let titleTop = CGFloat(28)
        static let defaultVerticalSpace = CGFloat(18)
        static let plainTextToTitleVerticalSapce = CGFloat(15)
        static let highlitedTextLeading = CGFloat(52)
        static let highlitedTextTop = CGFloat(14)
        static let textVerticalSpace = CGFloat(14)
        static let arabicTextTop = CGFloat(19)
        static let arabicTextBottom = CGFloat(19)
        static let arabicTextTrailing = CGFloat(37)
        static let arabicTextToCheckVerticalSpace = CGFloat(42)
        static let textToCheckVerticalSpace = CGFloat(32)
        static let checkHeight = CGFloat(41)
        static let imageLeadingTrailing = CGFloat(0)
        static let soundBottom = CGFloat(6)
        
        static let soundImageViewDefaultColor = UIColor.warmGrey
        static let soundImageViewPlayingColor = UIColor.blueberry
    }
    
    private enum Element {
        case plainText
        case highlitedText
        case arabicText
        case title
        case image
        case check
        case sound
    }
    
    
    // MARK: - Class private properties
    
    static var plainTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.avNext, size: 20)
        textStyle.minimumLineHeight = 30
        textStyle.color = .greyishBrown
        
        return textStyle
    }
    
    static var highlitedTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.avNextMed, size: 20)
        textStyle.minimumLineHeight = 30
        textStyle.color = .greyishBrown
        
        return textStyle
    }
    
    static var arabicTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.simpleArabic, size: 40)
        textStyle.color = .blueberry
        textStyle.alignment = .right
        
        return textStyle
    }
    
    static var titleTextStyle: GLBTextStyle {
        let textStyle = GLBTextStyle()
        textStyle.font = FontCreator.fontWithName(FontNames.avNext, size: 24)
        textStyle.color = .greyishBrown
        textStyle.alignment = .center
        textStyle.minimumLineHeight = 25
        textStyle.maximumLineHeight = 25
        
        return textStyle
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    
    // MARK: - Public properties
    
    var isPlayingSound = false {
        didSet {
            soundImageView?.tintColor = isPlayingSound ?
                Constants.soundImageViewPlayingColor : Constants.soundImageViewDefaultColor
        }
    }
    
    var fontSizeAddition = 0
    
    
    // MARK: - Private properties
    
    private var soundImageView: UIImageView?

    
    // MARK: - ModelTransfer
    
    typealias ModelType = LessonCardViewModel
    
    func update(with model: LessonCardViewModel) {
        tag = model.index ?? 0
        
        subviews.forEach { $0.removeFromSuperview() }
        
        var prevElement: Element? = nil
        var previousView: UIView? = nil
        
        if model.hasSound {
            previousView = addSoundImage(withPreviousElement: prevElement, previousView: previousView)
            prevElement = .sound
        }
        
        if let title = model.title {
            previousView = addTitleLabel(
                with: title,
                previousElement: prevElement,
                previousView: previousView)
            prevElement = .title
        }
        
        model.contentItemsValues.forEach { contentItemValue in
            let currentElement = LessonCardView.element(for: contentItemValue)
            
            switch contentItemValue {
            case .plainText(let text), .highlitedText(let text), .arabic(let text):
                previousView = addLabel(
                    for: currentElement,
                    withPreviousElement: prevElement,
                    text: text,
                    previousView: previousView)
            case .image(let image):
                previousView = addImageView(
                    forPreviousElement: prevElement,
                    image: image,
                    previousView: previousView)
                break
            }
            
            prevElement = currentElement
        }
        
        previousView = addCheck(
            withPreviousElement: prevElement,
            previousView: previousView)
        
        let space = LessonCardView.verticalSpace(between: .check, and: nil)
        
        previousView?.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().offset(-space)
        }
        
        addLine()
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    deinit {
        endObservingFontSizeAdjustments()
    }
    
    
    // MARK: - Private methods
    
    private func configure() {
        beginObservingFontSizeAdjustments()
        backgroundColor = .white
    }

    private func addSoundImage(
        withPreviousElement previousElement: Element?,
        previousView: UIView?) -> UIImageView {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sound"))
        imageView.tintColor = Constants.soundImageViewDefaultColor
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            let top = LessonCardView.verticalSpace(between: previousElement, and: .sound)
            
            maker.centerX.equalToSuperview()
            if let prev = previousView {
                maker.top.equalTo(prev.snp.bottom).offset(top)
            } else {
                maker.top.equalToSuperview().offset(top)
            }
        }
        
        soundImageView = imageView
        
        return imageView
    }

    private func addTitleLabel(
        with text: String,
        previousElement: Element?,
        previousView: UIView?) -> UILabel {
        let attributedText = NSAttributedString(
            string: text,
            attributes: LessonCardView.titleTextStyle.textAttributes)
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            let (leading, trailing) = LessonCardView.leadingAndTrailing(for: .title)
            let top = LessonCardView.verticalSpace(between: previousElement, and: .title)
            
            maker.leading.equalToSuperview().offset(leading)
            maker.trailing.equalToSuperview().offset(-trailing)
            if let prev = previousView {
                maker.top.equalTo(prev.snp.bottom).offset(top)
            } else {
                maker.top.equalToSuperview().offset(top)
            }
        }
        
        return titleLabel
    }
    
    private func addLabel(
        for element: Element,
        withPreviousElement previousElement: Element?,
        text: String,
        previousView: UIView?) -> UILabel? {
        
        var optionalTextStyle: GLBTextStyle? = nil
        
        switch element {
        case .plainText:
            optionalTextStyle = LessonCardView.plainTextStyle
        case .highlitedText:
            optionalTextStyle = LessonCardView.highlitedTextStyle
        case .arabicText:
            optionalTextStyle = LessonCardView.arabicTextStyle
        default:
            break
        }
        
        guard let textStyle = optionalTextStyle else { return nil }
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: textStyle.textAttributes)
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedText
        
        addSubview(label)
        label.snp.makeConstraints { maker in
            let (leading, trailing) = LessonCardView.leadingAndTrailing(for: element)
            let top = LessonCardView.verticalSpace(between: previousElement, and: element)
            
            maker.leading.equalToSuperview().offset(leading)
            maker.trailing.equalToSuperview().offset(-trailing)
            
            if let prevView = previousView {
                maker.top.equalTo(prevView.snp.bottom).offset(top)
            } else {
                maker.top.equalToSuperview().offset(top)
            }
        }
        
        return label
    }
    
    private func addImageView(
        forPreviousElement previousElement: Element?,
        image: UIImage,
        previousView: UIView?) -> UIImageView? {
        
        let imageView = UIImageView(image: image)
        addSubview(imageView)
        
        let imageSize = image.size
        let aspectRatio = imageSize.height / imageSize.width
        
        imageView.snp.makeConstraints { maker in
            let (leading, trailing) = LessonCardView.leadingAndTrailing(for: .image)
            let top = LessonCardView.verticalSpace(between: previousElement, and: .image)
            
            maker.leading.equalToSuperview().offset(leading)
            maker.trailing.equalToSuperview().offset(-trailing)
            maker.height.equalTo(imageView.snp.width).multipliedBy(aspectRatio)
            
            if let prevView = previousView {
                maker.top.equalTo(prevView.snp.bottom).offset(top)
            } else {
                maker.top.equalToSuperview().offset(top)
            }
        }
        
        return imageView
    }
    
    private func addCheck(
        withPreviousElement previousElement: Element?,
        previousView: UIView?) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "not-done"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "done"), for: .selected)
        button.addTarget(self, action: #selector(checkPressed(_:)), for: .touchUpInside)
        addSubview(button)
        
        button.snp.makeConstraints { maker in
            let top = LessonCardView.verticalSpace(between: previousElement, and: .check)
            
            maker.centerX.equalToSuperview()
            
            if let prevView = previousView {
                maker.top.equalTo(prevView.snp.bottom).offset(top)
            } else {
                maker.top.equalToSuperview().offset(top)
            }
        }
        
        return button
    }
    
    private func addLine() {
        let line = UIView()
        line.backgroundColor = .warmGrey30
        addSubview(line)
        line.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
//    // MARK: - Class public methods
//    
//    class func height(for model: LessonCardViewModel) -> CGFloat {
//        var totalHeight = CGFloat(0)
//        
//        var previous: Element? = nil
//        var current: Element
//        
//        if let title = model.title {
//            current = .title
//            totalHeight += verticalSpace(between: previous, and: current)
//            totalHeight += height(
//                for: current,
//                with: title,
//                attributes: titleTextStyle.textAttributes)
//            
//            previous = current
//        }
//        
//        for contentItemValue in model.contentItemsValues {
//            current = element(for: contentItemValue)
//            totalHeight += verticalSpace(between: previous, and: current)
//            
//            switch contentItemValue {
//            case .arabic(let text):
//                totalHeight += height(
//                    for: current,
//                    with: text,
//                    attributes: arabicTextStyle.textAttributes)
//            case .plainText(let text):
//                totalHeight += height(
//                    for: current,
//                    with: text,
//                    attributes: plainTextStyle.textAttributes)
//            case .highlitedText(let text):
//                totalHeight += height(
//                    for: current,
//                    with: text,
//                    attributes: highlitedTextStyle.textAttributes)
//            default:
//                break
//            }
//            
//            previous = current
//        }
//        
//        totalHeight += verticalSpace(between: previous, and: .check)
//        totalHeight += Constants.checkHeight
//        totalHeight += verticalSpace(between: .check, and: nil)
//        
//        return totalHeight
//    }
    
    // MARK: - Actions
    
    @objc private func checkPressed(_ checkButton: UIButton) {
        checkButton.isSelected = !checkButton.isSelected
    }
    
    
    // MARK: - Class private methods
    
    private static func verticalSpace(
        between first: Element?,
        and second: Element?) -> CGFloat {
        
        let defaultSpace = Constants.defaultVerticalSpace
        
        if first == nil {
            guard let second = second else { return defaultSpace }
            
            switch second {
            case .title:
                return Constants.titleTop
            default:
                return Constants.top
            }
        } else if second == nil {
            return Constants.bottom
        } else {
            guard let first = first, let second = second else { return defaultSpace }
            
            switch first {
            case .plainText:
                switch second {
                case .plainText:
                    return Constants.textVerticalSpace
                case .highlitedText:
                    return Constants.highlitedTextTop
                case .arabicText:
                    return Constants.arabicTextTop
                case .check:
                    return Constants.textToCheckVerticalSpace
                default:
                    return defaultSpace
                }
            case .highlitedText:
                switch second {
                case .plainText:
                    return Constants.textVerticalSpace
                case .highlitedText:
                    return Constants.highlitedTextTop
                case .arabicText:
                    return Constants.arabicTextTop
                case .check:
                    return Constants.textToCheckVerticalSpace
                default:
                    return defaultSpace
                }
            case .title:
                return Constants.plainTextToTitleVerticalSapce
            case .arabicText:
                switch second {
                case .plainText, .highlitedText:
                    return Constants.arabicTextBottom
                case .check:
                    return Constants.arabicTextToCheckVerticalSpace
                default:
                    return defaultSpace
                }
            case .sound:
                switch second {
                case .title:
                    return Constants.titleTop
                default:
                    return Constants.soundBottom
                }
            default:
                return defaultSpace
            }
        }
    }
    
    private static func leadingAndTrailing(for element: Element) -> (CGFloat, CGFloat) {
        var leading, trailing: CGFloat
        
        switch element {
        case .highlitedText:
            leading = Constants.highlitedTextLeading
            trailing = Constants.trailing
        case .arabicText:
            leading = Constants.leading
            trailing = Constants.arabicTextTrailing
        case .image:
            leading = Constants.imageLeadingTrailing
            trailing = Constants.imageLeadingTrailing
        default:
            leading = Constants.leading
            trailing = Constants.trailing
        }
        
        return (leading, trailing)
    }
    
    private static func height(
        for element: Element,
        with text: String,
        attributes: [NSAttributedStringKey: Any]?) -> CGFloat {
        
        let (leading, trailing) = leadingAndTrailing(for: element)
        
        let text = text as NSString
        let width = screenWidth - leading - trailing
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let height = text.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil)
            .height
        
        return ceil(height)
    }
    
    private static func element(for contentItemValue: LessonCardContentItemValue) -> Element {
        switch contentItemValue {
        case .plainText(_):
            return .plainText
        case .highlitedText(_):
            return .highlitedText
        case .arabic(_):
            return .arabicText
        case .image(_):
            return .image
        }
    }
    
}


extension LessonCardView: FontSizeAdjustmentsObserving {
    
    func beginObservingFontSizeAdjustments() {
        FontCreator.addFontSizeAdjustmentsObserver(self)
    }
    
    func endObservingFontSizeAdjustments() {
        FontCreator.removeFontSizeAdjustmentsObserver(self)
    }
    
    func adjustFontSize(to value: CGFloat) {
        subviews.forEach { subview in
            if let label = subview as? UILabel {
                label.font = UIFont(
                    name: label.font.fontName,
                    size: label.font.pointSize + value)
            }
        }
    }
    
}

