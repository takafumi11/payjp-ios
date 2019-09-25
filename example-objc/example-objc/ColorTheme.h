//
//  ColorStyle.h
//  example-objc
//
//  Created by Tadashi Wakayanagi on 2019/09/25.
//  Copyright © 2019 PAY, Inc. All rights reserved.
//

#ifndef ColorStyle_h
#define ColorStyle_h

typedef NS_ENUM(NSInteger, ColorTheme) {
    Nomal,
    Red,
    Blue,
    Dark
};
#define GetColorThemeText(type) ColorThemeTextList[type]
#define GetColorTheme(typeText) (ColorTheme)[ColorThemeTextList indexOfObject:typeText]
#define ColorThemeTextList @[@"Nomal",@"Red",@"Blue",@"Dark"]

#endif /* ColorStyle_h */
