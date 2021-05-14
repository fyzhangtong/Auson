//
//  CommonConfig.h
//  zhangtong
//
//  Created by Mac on 16/10/17.
//  Copyright © 2021年 zhangtong. All rights reserved.
//

#ifndef CommonConfig_h
#define CommonConfig_h

/// 是iphone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/// 是ipad
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
/// 获取keywindow
#define KWindow [UIApplication sharedApplication].keyWindow

/// ------------------------------------------------大小------------------------------------------------
/// 屏幕宽
#define GTSCREENW [UIScreen mainScreen].bounds.size.width
/// 屏幕高
#define GTSCREENH [UIScreen mainScreen].bounds.size.height
/// 获取实际大小
#define RV_WIDTH(value,design) ((value)/(design) * GTSCREENW)
/// 按iPhone6 375.0f成比例
#define RV(value) RV_WIDTH((value),(375.f))
/// 按iPhone6 667.f成比例
#define RH(value) ((value)/(667.f) * GTSCREENH)

/// 状态栏高度
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 130000
/// 支持iOS13以上
#define SafeIphoneXStatusHeader [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height
#else
/// 支持iOS 12以上
#define SafeIphoneXStatusHeader [[UIApplication sharedApplication] statusBarFrame].size.height
#endif

/// 导航栏高度
#define GTNAVIGATIONBARHEIGHT (SafeIphoneXStatusHeader + 44)
/// tabbar高度
#define GTTABBARHEIGHT (SafeIphoneXStatusHeader > 20 ? 83 : 49)
/// 全面屏bottom
#define safeIphoneXFooter (SafeIphoneXStatusHeader > 20  ? 25 : 0)

/// ------------------------------------------------字体名------------------------------------------------
#define FD_FONT_BOLD @"AvenirNext-Bold"
#define FDFONT_PINGFANGSC_MEDIUM @"PingFangSC-Medium"
#define FDFONT_PINGFANGSC_REGULAR @"PingFangSC-Regular"
#define FDFONT_PINGFANGSC_SEMIBOLD @"PingFangSC-Semibold"
#define FDFONT_HYT_REGULAR @"zcoolqingkehuangyouti-Regular"

/// ------------------------------------------------颜色------------------------------------------------
#define GTColor(HexStr)  [UIColor colorWithHexString:HexStr]
/// 全局色调
#define GlobalColor [UIColor colorWithHexString:@"#00c864"]
/// 灰色阴影
#define ShadowBackColor [UIColor colorWithHex:0xcccccc]
/// 请求图片时的占位颜色
#define PLACEHODLER_COLOR [UIColor colorWithHexString:@"#eeecd8"]

/// ------------------------------------------------array & dictionary-----------------------------------------------
/// safeArray
#define SafeArrayObjectIndex(array, index) (array.count > index ? array[index] : nil)
#define SafeArrayAddObject(array, object) (object ? [array addObject:object] : nil)
/// safeDictionary
#define SafeDictionarySetObject(dictionary, object, key) ((object != nil && key != nil) ? [dictionary setObject:object forKey:key] : nil)

/// ------------------------------------------------请求本地plist文件------------------------------------------------

/// ------------------------------------------------文案------------------------------------------------
#define ERROR_NETWORK_TIP @"网络开小差了，请检查您的网络环境"

#endif /* CommonConfig_h */
