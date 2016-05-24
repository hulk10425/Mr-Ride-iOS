//
//  UIFont+MRAdditions.swift
//
//  Generated by Zeplin on 5/23/16.
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved. 
//

import UIKit

extension UIFont {
    
    class func mrHelveticaFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica", size: size)
    }
    
    class func mrHelveticaBoldFont(size: CGFloat) -> UIFont? {
		return UIFont(name: "Helvetica-Bold", size: size)
	}

    class func mrPingFangTCMediumFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: size)
    }
    
    class func mrRobotoMonoLightFon(size: CGFloat) -> UIFont? {
        return UIFont(name: "RobotoMono-Light", size: size)
    }
    
    class func mrSFUITextRegularFont(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightRegular)
    }

    class func mrSFUITextMediumFont(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightMedium)
    }

    class func mrSFUITextBoldFon(size: CGFloat) -> UIFont {
		return UIFont.systemFontOfSize(size, weight: UIFontWeightBold)
	}
    

    

}
