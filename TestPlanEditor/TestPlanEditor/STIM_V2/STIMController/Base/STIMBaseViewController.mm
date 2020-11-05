//
//  StimMainVC
//  STIM_Pannel
//
//  Created by ciwei luo on 2019/10/17.
//  Copyright © 2019 macdev. All rights reserved.
//

#define LogFOLDER @"/vault/StimLog"
#define textF_W 200
#define textF_h 60
#import "STIMBaseViewController.h"


@interface STIMBaseViewController ()
@property (nonatomic,strong)NSButton *lastBtn1;
@property (nonatomic,strong)NSButton *lastBtn2;
@property (nonatomic,copy)NSArray *mutexSwitchsArr1;
@property (nonatomic,copy)NSArray *mutexSwitchsArr2;

@property (nonatomic,strong)NSButton *lastBtn_dmic;

//@property (nonatomic,copy)NSArray *switchsArr_dmic;
@end


@implementation STIMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    


}



-(void)removeLogFile{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    [fileManager removeItemAtPath:LogFOLDER error:nil];
}


-(void)resetRelays{

    if (!self.allSwitchs.count) {
        return;
    }
    for (int i =0; i<self.allSwitchs.count; i++) {
        NSArray *arr =self.allSwitchs[i];
        for (NSButton *btn in arr) {
            btn.state=0;
            if (i==0) {
                [self setSwitch1BtnImage:btn];
            }else{
                [self setSwitch2BtnImage:btn];
            }
            
        }
    }
    
}


-(void)setSwitch1BtnImage:(NSButton *)switchBtn{
    if (switchBtn.state) {
        [switchBtn setImage:[NSImage imageNamed:@"switch1_on"]];
    }else{
        [switchBtn setImage:[NSImage imageNamed:@"switch1_off"]];
    }
}
-(void)setSwitch2BtnImage:(NSButton *)switchBtn{
    if (switchBtn.state) {
        [switchBtn setImage:[NSImage imageNamed:@"switch2_on"]];
    }else{
        [switchBtn setImage:[NSImage imageNamed:@"switch2_off"]];
    }
}


-(void)mutexSwitchsStateWithCurrentSelectedBtn1:(NSButton *)switchBtn WithSwitchsArray:(NSArray *)switchs{
    self.mutexSwitchsArr1 = switchs;
    [self changeSwitchStateWithSelectBtn:switchBtn];
    [self setSwitch1BtnImage:switchBtn];
    self.lastBtn1=switchBtn;
}
-(void)mutexSwitchsStateWithCurrentSelectedBtn2:(NSButton *)switchBtn WithSwitchsArray:(NSArray *)switchs{
    self.mutexSwitchsArr2 = switchs;
    [self changeSwitchStateWithSelectBtn:switchBtn];
    [self setSwitch1BtnImage:switchBtn];
    self.lastBtn2=switchBtn;
}

-(void)dmicSwitchsStateWithCurrentSelectedBtn:(NSButton *)switchBtn WithSwitchsArray:(NSArray *)switchs{
    NSControlStateValue btnState = switchBtn.state;
    if (switchBtn.tag==_lastBtn_dmic.tag) {
        for (NSArray *btns in switchs) {
            if ([btns containsObject:switchBtn]) {
                for (NSButton *btn in btns) {
                    btn.state=btnState;
                    [self setSwitch1BtnImage:btn];
                }
            }
        }
    }else{
        
        for (NSArray *btns in switchs) {
            if ([btns containsObject:switchBtn]) {
                for (NSButton *btn in btns) {
                    btn.state=btnState;
                    [self setSwitch1BtnImage:btn];
                }
            }else{
                for (NSButton *otherBtn in btns) {
                    otherBtn.state = !btnState;
                    [self setSwitch1BtnImage:otherBtn];
                }
            }
        }
    }
    
    _lastBtn_dmic = switchBtn;
    
//    [CommandHandler generateCommandWithSwitchBtn:switchBtn text:@""];
}


-(void)changeSwitchStateWithSelectBtn:(NSButton *)switchBtn{
    
    NSButton *lastBtn = nil;
    if ([self.mutexSwitchsArr2 containsObject:switchBtn]) {
        lastBtn = self.lastBtn2;
    }else if ([self.mutexSwitchsArr1 containsObject:switchBtn]){
        lastBtn = self.lastBtn1;
    }
    
    if (lastBtn==switchBtn) {
        return;
    }else{
        if (lastBtn) {
            NSControlStateValue state =!switchBtn.state;
            [lastBtn setState:state];
            [self setSwitch1BtnImage:lastBtn];
        }
    }
    
    lastBtn = switchBtn;
}


-(void)dealloc{
  //  [super dealloc];
    NSLog(@"%s",__func__);

}


-(NSTextField *)m_measurment{
    if (!_m_measurment) {
        _m_measurment = [[NSTextField alloc]init];
        _m_measurment.frame = NSMakeRect(3, 620, 300, 50);
//        _m_measurment.wantsLayer=YES;
//        _m_measurment.layer.backgroundColor=[NSColor redColor].CGColor;
        _m_measurment.bordered = NO;
        _m_measurment.drawsBackground = NO;
//        _m_measurment.stringValue= @"resultresultresultresultresultresultresultresultresultresultresultresult";
        _m_measurment.alignment=NSTextAlignmentLeft;
        _m_measurment.textColor=[NSColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _m_measurment.editable = NO;
        [self.view addSubview:_m_measurment];
    }
    return _m_measurment;
}


@end
