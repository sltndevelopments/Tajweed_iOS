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
        static let plainTextToTitleVerticalSapce = CGFloat(15)
        static let highlitedTextLeading = CGFloat(52)
        static let highlitedTextTop = CGFloat(8)
        static let textVerticalSpace = CGFloat(14)
        static let arabicTextTop = CGFloat(19)
        static let arabicTextBottom = CGFloat(19)
        static let arabicTextTrailing = CGFloat(37)
        static let arabicTextToCheckVerticalSpace = CGFloat(22)
        static let textToCheckVerticalSpace = CGFloat(32)
        static let checkHeight = CGFloat(41)
    }
    
    private enum Element {
        case plainText
        case highlitedText
        case arabicText
        case title
        case image
        case check
    }
    
    
    // MARK: - Class private properties
    
    static var plainTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.avNext, size: 20)
        textStyle.minimumLineHeight = 30
        textStyle.color = .greyishBrown
        
        return textStyle
    }()
    
    static var highlitedTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.avNextMed, size: 20)
        textStyle.minimumLineHeight = 30
        textStyle.color = .greyishBrown
        
        return textStyle
    }()
    
    static var arabicTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.arialMT, size: 40)
        textStyle.color = .blueberry
        textStyle.alignment = .right
        
        return textStyle
    }()
    
    static var titleTextStyle: GLBTextStyle = {
        let textStyle = GLBTextStyle()
        textStyle.font = UIFont(name: FontNames.avNext, size: 24)
        textStyle.color = .greyishBrown
        textStyle.alignment = .center
        textStyle.minimumLineHeight = 25
        textStyle.maximumLineHeight = 25
        
        return textStyle
    }()
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    
    // MARK: - ModelTransfer
    
    typealias ModelType = LessonCardViewModel
    
    func update(with model: LessonCardViewModel) {
        subviews.forEach { $0.removeFromSuperview() }
        
        var prevElement: Element? = nil
        var previousView: UIView? = nil
        
        if let title = model.title {
            previousView = addTitleLabel(with: title)
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
            default:
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
    
    
    // MARK: - Private methods
    
    private func configure() {
        backgroundColor = .white
    }

    private func addTitleLabel(with text: String) -> UILabel {
        let attributedText = NSAttributedString(
            string: text,
            attributes: LessonCardView.titleTextStyle.textAttributes)
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            let (leading, trailing) = LessonCardView.leadingAndTrailing(for: .title)
            let top = LessonCardView.verticalSpace(between: nil, and: .title)
            
            maker.leading.equalToSuperview().offset(leading)
            maker.trailing.equalToSuperview().offset(-trailing)
            maker.top.equalToSuperview().offset(top)
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
    
    private func addCheck(
        withPreviousElement previousElement: Element?,
        previousView: UIView?) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "done"), for: .normal)
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
    
    
    // MARK: - Class private methods
    
    private static func verticalSpace(
        between first: Element?,
        and second: Element?) -> CGFloat {
        
        let defaultSpace = CGFloat(0)
        
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

