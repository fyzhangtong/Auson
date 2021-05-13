

#import "UIColor+RP.h"

@implementation UIColor (RP)

+ (UIColor *)colorWithHexString:(NSString *)str
{
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x];
}

+ (UIColor *)colorWithHex:(NSUInteger)col
{
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (UIColor *)vst_bg_grayColor
{
    return [UIColor colorWithRed:239.0f/255.0f green:238.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
}

@end
