//
//  CommandHandler
//  STIM_Pannel
//
//  Created by ciwei luo on 2019/10/17.
//  Copyright © 2019 macdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "DebugLog.h"
#import "ExtensionConst.h"
@interface CommandHandler : NSObject
+(NSDictionary *)getSitmDatas;
+(void)FixtureReset;
+(NSString *)generateCommandWithSwitchBtn:(NSButton *)switchBtn text:(NSString *)strButtonBlindTextfile vcTitle:title;

+(NSString *)generateCommandWithPrefix:(NSString *)sPrefix nidentifier:(int)nidentifier nstate:(int)nstate text:(NSString *)strButtonBlindTextfile vcTitle:(NSString *)title;
@end
