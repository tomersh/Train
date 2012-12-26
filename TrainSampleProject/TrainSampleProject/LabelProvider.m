//
// Created by tomer on 12/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LabelProvider.h"
#import "ColorProvider.h"
#import "TextProvider.h"
#import "FontProvider.h"
#import "AutoresizingMaskProvider.h"

@interface LabelProvider () {
    ColorProvider* _ioc_ColorProvider;
    TextProvider* _ioc_TextProvider;
    FontProvider* _ioc_FontProvider;
    AutoresizingMaskProvider* _ioc_AutoResizingMaskProvider;
}

@property (nonatomic, readonly) ColorProvider* colorProvider;
@property (nonatomic, readonly) TextProvider* textProvider;
@property (nonatomic, readonly) FontProvider* fontProvider;
@property (nonatomic, readonly) AutoresizingMaskProvider* autoResizingMaskProvider;

@end

@implementation LabelProvider

@synthesize colorProvider = _ioc_ColorProvider,
            textProvider = _ioc_TextProvider,
            fontProvider = _ioc_FontProvider,
            autoResizingMaskProvider = _ioc_AutoResizingMaskProvider;

-(UILabel*) provideButtonWithFrame:(CGRect) frame {
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    
    label.backgroundColor = [self.colorProvider buttonColor];

    label.textColor = [self.colorProvider textColor];

    label.text = [self.textProvider buttonText];

    label.textAlignment = NSTextAlignmentCenter;

    label.font = [self.fontProvider buttonFont];
    
    label.autoresizingMask = [self.autoResizingMaskProvider centeredAutoresizingMask];
    
    return [label autorelease];
}

@end