import UIKit

public class SnapTagCell: UICollectionViewCell {

    weak var sizer : SnapTextWidthSizers?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!

    @IBOutlet weak var backgroundImageForOnState: UIImageView!
    @IBOutlet weak var backgroundImageForOffState: UIImageView!

    @IBOutlet weak var highlightBackground: UIView!

    @IBOutlet weak var onOffButton: UIView!
    @IBOutlet weak var onButtonImage: UIImageView!
    @IBOutlet weak var offButtonImage: UIImageView!

    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    @IBOutlet weak var trailingMargin: NSLayoutConstraint!
    @IBOutlet weak var spacingMargin: NSLayoutConstraint!

    @IBOutlet var onOffButtonDimensions: [NSLayoutConstraint]!

    internal var configuration : SnapTagButtonConfiguration!
    internal var lastText: String = "Snapsale"

    public func setOnState() {
        backgroundImageForOnState.alpha = 1.0
        backgroundImageForOffState.alpha = 0.0
        onButtonImage.alpha = 0.0
        offButtonImage.alpha = 1.0
        onOffButton.transform = configuration.onState.buttonTransform
        setTextColor(configuration.onState.textColor)

        highlightBackground.backgroundColor = configuration.highlightedWhileOnState.backgroundColor
        highlightBackground.layer.cornerRadius = configuration.highlightedWhileOnState.cornerRadius

        self.selected = true
    }

    public func setOffState() {
        backgroundImageForOnState.alpha = 0.0
        backgroundImageForOffState.alpha = 1.0
        onButtonImage.alpha = 1.0
        offButtonImage.alpha = 0.0
        onOffButton.transform = configuration.offState.buttonTransform
        setTextColor(configuration.offState.textColor)

        highlightBackground.backgroundColor = configuration.highlightedWhileOffState.backgroundColor
        highlightBackground.layer.cornerRadius = configuration.highlightedWhileOffState.cornerRadius

        self.selected = false
    }

    public func setHighlightState(enabled : Bool) {
        let onValue = configuration.isOn ?
            configuration.highlightedWhileOnState.alpha :
            configuration.highlightedWhileOffState.alpha

        self.highlightBackground.alpha = enabled ? onValue : 0.0
    }

    public func applyConfiguration(configuration: SnapTagButtonConfiguration) {
        self.configuration = configuration

        setupMargins()
        setupBackground()
        setupLabel()
        setupOnOffButton()

        if configuration.isOn {
            setOnState()
        } else {
            setOffState()
        }
    }

    public override func intrinsicContentSize() -> CGSize {
        return configuration.intrinsicContentSize
    }

    public func setTextColor(color: UIColor) {
        label.textColor = color
    }

    internal func setupBackground() {
        setBackgroundColor(onColor: configuration.onState.backgroundColor, offColor: configuration.offState.backgroundColor)
        setBackgroundImages(onImage: configuration.onState.backgroundImage, offImage: configuration.offState.backgroundImage)
        backgroundImageForOnState.layer.cornerRadius = configuration.onState.cornerRadius
        backgroundImageForOnState.layer.masksToBounds = true
        backgroundImageForOffState.layer.cornerRadius = configuration.offState.cornerRadius
        backgroundImageForOffState.layer.masksToBounds = true

        if let onBorderColor = configuration.onState.borderColor,
            let onBorderWidth = configuration.onState.borderWidth {
                backgroundImageForOnState.layer.borderColor = onBorderColor.CGColor
                backgroundImageForOnState.layer.borderWidth = onBorderWidth
        }

        if let offBorderColor = configuration.offState.borderColor,
            let offBorderWidth = configuration.offState.borderWidth {
                backgroundImageForOffState.layer.borderColor = offBorderColor.CGColor
                backgroundImageForOffState.layer.borderWidth = offBorderWidth
        }

    }

    internal func setupLabel() {
        setFont(configuration.font)
    }

    internal func setupOnOffButton() {
        if configuration.hasOnOffButton {
            enableOnOffButton()
        } else {
            disableOnOffButton()
        }
    }

    internal func setupMargins() {
        topMargin.constant = configuration.horizontalMargin + configuration.labelVOffset
        bottomMargin.constant = configuration.horizontalMargin - configuration.labelVOffset
        leadingMargin.constant = configuration.verticalMargin + configuration.labelHOffset
    }

    internal func disableOnOffButton() {
        for constraint in onOffButtonDimensions {
            constraint.constant = 0.0
        }
        spacingMargin.constant = 0.0
    }

    internal func enableOnOffButton() {
        for constraint in onOffButtonDimensions {
            constraint.constant = (configuration.onState.buttonImage?.size.height ?? 0.0) / 2.0
        }
        spacingMargin.constant = configuration.onState.spacingBetweenLabelAndOnOffButton
    }

    internal func setFont(font: UIFont) {
        label.font = font
        if label.text != "" {

            let size = sizeForLabel(label)
            labelWidth.constant = size.width
        }
    }

    internal func sizeForLabel(label: UILabel) -> CGSize {
        let size : CGSize
        if let sizer = sizer {
            size = sizer.calculateSizeFor(label.text ?? "", font: label.font)
        } else {
            size = label.sizeThatFits(CGSizeMake(2000, 100))
        }
        return size
    }

    internal func setText(text: String) {
        lastText = text.uppercaseString
        label.text = text.uppercaseString

        let size = sizeForLabel(label)
        labelWidth.constant = size.width
    }

    internal func setBackgroundImages(onImage onImage: UIImage?, offImage: UIImage?) {
        backgroundImageForOnState.image = onImage
        backgroundImageForOffState.image = offImage
    }

    internal func setBackgroundColor(onColor onColor: UIColor?, offColor: UIColor?) {
        backgroundImageForOnState.backgroundColor = onColor
        backgroundImageForOffState.backgroundColor = offColor
    }

    // And the classic bug-fix
    override public var bounds: CGRect {
        didSet {
            contentView.frame = bounds
            contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        }
    }

    public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        var width : CGFloat
        var height : CGFloat

        if let sizer = sizer {
            let size = sizer.calculateSizeFor(lastText, font: configuration.font)
            width = size.width
            width += configuration.horizontalMargin * 2

            if configuration.hasOnOffButton {
                width += configuration.onState.spacingBetweenLabelAndOnOffButton
                width += configuration.onState.buttonImage?.size.width ?? 0.0
            }

            height = size.height
            height += configuration.verticalMargin * 2

        } else {
            print("argh")
            width = configuration.intrinsicContentSize.width
            height = configuration.intrinsicContentSize.height
        }

        let size = CGSizeMake(round(width), round(height))

        if size == layoutAttributes.frame.size {
            print("yay")
            return layoutAttributes
        } else {


            let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes

            var frame = layoutAttributes.frame
            frame.size.height = size.height
            if abs(frame.size.width - size.width) > 2.0 { // Less is just not worth quarelling about
                print("\(size.width) vs \(layoutAttributes.frame.size.width)")
                frame.size.width = size.width
            }
            attr.frame = frame
            return attr
        }
    }
}
