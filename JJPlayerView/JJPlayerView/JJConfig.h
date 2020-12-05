//
//  JJConfig.h
//  JJPlayerView
//
//  Created by zhouxuanhe on 2020/12/5.
//

#ifndef JJConfig_h
#define JJConfig_h


/** tabbar、导航条、状态栏高度 */
#define kTabBarHeight  (kIs_iPhone_X ? 83 : 49)
#define kNavBarHeight  (kIs_iPhone_X ? 88 : 64)
#define kNavBarContentHeight  44
#define kStatusBarHeight (kIs_iPhone_X ? 44 : 20)
/** 距离底部安全距离 */
#define kBottomSafeHeight  (kIs_iPhone_X ? 34 : 0)
/** 常用对象 */
#define kAppWindow [[[UIApplication sharedApplication] delegate] window]
/** 屏幕宽高 */
#define KScreenWidth    ([[UIScreen mainScreen] bounds].size.height < [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight   ([[UIScreen mainScreen] bounds].size.height > [[UIScreen mainScreen] bounds].size.width ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

 

#define kIs_iPhone_X (KScreenHeight == 812.0 || KScreenHeight == 896 || KScreenHeight == 844 || KScreenHeight == 926 || KScreenHeight == 780)
//#define kIs_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


/// 字体苹方
#define J_KFont(fontName,fontSize) ({\
                UIFont * font = [UIFont fontWithName:fontName size:fontSize];\
                if (!font) {\
                    font = [UIFont systemFontOfSize:fontSize weight:fontSize];\
                }\
                    font;\
                })
#define kFont_Semibold(f)       J_KFont(@"PingFangSC-Semibold",f)
#define kFont_Medium(f)         J_KFont(@"PingFangSC-Medium",f)
#define kFont_Regular(f)        J_KFont(@"PingFangSC-Regular",f)
#define kFont(f)                [UIFont systemFontOfSize:f]
#define kFont_Blod(f)                [UIFont systemFontOfSize:f]

#endif /* JJConfig_h */
