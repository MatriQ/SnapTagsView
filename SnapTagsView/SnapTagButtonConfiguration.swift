import Foundation

public class SnapTagButtonConfiguration : NSObject {
    
    public var isOn : Bool = true
    
    public var font : UIFont!

    public var onTextColor : UIColor!
    public var offTextColor : UIColor!

    
    public var onBackgroundImage : UIImage!
    public var offBackgroundImage : UIImage!
    
    public var onBackgroundColor : UIColor!
    public var offBackgroundColor : UIColor!
    
    public var isTurnOnOffAble: Bool = false
    
    public var horizontalMargin : CGFloat = 10.0
    public var verticalMargin : CGFloat = 10.0
    public var cornerRadius : CGFloat = 5.0
    
    public var onOffButtonImage : OnOffButtonConfiguration!
    
    public var spacingBetweenLabelAndOnOffButton : CGFloat = 8.0
    
    public var intrinsicContentSize = CGSizeMake(30, 30)
    
    public override init() {
        super.init()
        
        onOffButtonImage = OnOffButtonConfiguration()
    }
    
    public convenience init(viewConfig: SnapTagsViewConfiguration) {
        self.init()
        
        horizontalMargin = viewConfig.horizontalMargin
    }
    
    public func duplicate() -> SnapTagButtonConfiguration {

        let copy = SnapTagButtonConfiguration()
        copy.isOn = isOn
        copy.font = font
        copy.onTextColor = onTextColor
        copy.offTextColor = offTextColor
        copy.onBackgroundImage = onBackgroundImage
        copy.offBackgroundImage = offBackgroundImage
        copy.onBackgroundColor = onBackgroundColor
        copy.offBackgroundColor = offBackgroundColor
        copy.isTurnOnOffAble = isTurnOnOffAble
        copy.horizontalMargin = horizontalMargin
        copy.verticalMargin = verticalMargin
        copy.cornerRadius = cornerRadius
        copy.onOffButtonImage = OnOffButtonConfiguration()
        copy.onOffButtonImage.onImage = onOffButtonImage.onImage
        copy.onOffButtonImage.offImage = onOffButtonImage.offImage
        copy.onOffButtonImage.onTransform = onOffButtonImage.onTransform
        copy.onOffButtonImage.offTransform = onOffButtonImage.offTransform
        copy.spacingBetweenLabelAndOnOffButton = spacingBetweenLabelAndOnOffButton
        copy.intrinsicContentSize = intrinsicContentSize
        
        return copy
    }
    
    public func isValid() -> Bool {
        var test = true
        
        test = test && font != nil
        test = test && onBackgroundColor != nil
        test = test && offBackgroundColor != nil
        test = test && onTextColor != nil
        test = test && offTextColor != nil
        test = test && onOffButtonImage != nil && onOffButtonImage.isValid()
        
        return test
    }
    
    public static func defaultConfiguration() -> SnapTagButtonConfiguration {
        let c = SnapTagButtonConfiguration()
        
        c.onOffButtonImage.onImage = UIImage.Asset.YellowCloseButton.image
        c.onOffButtonImage.offImage = UIImage.Asset.RedCloseButton.image
        
        c.onBackgroundImage = UIImage.Asset.RoundedButtonFilled.image
        c.offBackgroundImage = UIImage.Asset.RoundedButton.image
        c.font = UIFont.boldSystemFontOfSize(13.0)
        c.onBackgroundColor = UIColor.roseColor()
        c.offBackgroundColor = UIColor.whiteColor()
        c.onTextColor = UIColor.whiteColor()
        c.offTextColor = UIColor.roseColor()
        c.isTurnOnOffAble = true
        
        assert(c.isValid())
        return c
    }

}

