//
//  StimMainVC
//  STIM_Pannel
//
//  Created by ciwei luo on 2019/10/17.
//  Copyright © 2019 macdev. All rights reserved.
//
//NTCViewController
#import <Cocoa/Cocoa.h>
#import "CommandHandler.h"
#import "ExtensionConst.h"
@interface STIMBaseViewController : NSViewController
@property (nonatomic,copy)NSArray *allSwitchs;
-(void)resetRelays;
-(void)setSwitch1BtnImage:(NSButton *)switchBtn;
-(void)setSwitch2BtnImage:(NSButton *)switchBtn;

-(void)mutexSwitchsStateWithCurrentSelectedBtn1:(NSButton *)switchBtn WithSwitchsArray:(NSArray *)switchs;
-(void)mutexSwitchsStateWithCurrentSelectedBtn2:(NSButton *)switchBtn WithSwitchsArray:(NSArray *)switchs;


-(void)dmicSwitchsStateWithCurrentSelectedBtn:(NSButton *)switchBtn WithSwitchsArray:(NSArray *)switchs;
@property (nonatomic,strong)NSTextField *m_measurment;
//@property (nonatomic,strong)NSString *measurment;
@end
