//
//  EVMacros.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/23/14.
//
//

#import <Foundation/Foundation.h>


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]
#define COLOR_FROM_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define COLOR_FROM_HEX_AND_ALPHA(hexValue, alphaValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue]

#define FONT(s) [UIFont fontWithName:PRIMARY_FONT size:s]
#define FONT_TYPE(type, s) [UIFont fontWithName:@"HelveticaNeue-" type size:s]
