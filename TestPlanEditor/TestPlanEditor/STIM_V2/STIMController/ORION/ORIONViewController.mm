//
//  ORIONViewController
//  STIM_Pannel
//
//  Created by ciwei luo on 2019/10/17.
//  Copyright © 2019 macdev. All rights reserved.
//

#import "ORIONViewController.h"


@interface ORIONViewController ()
@property (assign) IBOutlet NSButton *switchBtn1;
@property (assign) IBOutlet NSButton *switchBtn2;
@property (assign) IBOutlet NSButton *switchBtn3;

@property (copy) NSArray *switchBtns;

@property (assign) IBOutlet NSTextField *textF;
@property (assign) IBOutlet NSButton *setBtn;
@end
typedef NS_ENUM(NSUInteger, OrionSwitchControlType) {
    OrionSwitchControlTypeOAB    = 0,
    OrionSwitchControlTypeProvider     = 1,
    OrionSwitchControlTypeConsumer            = 2,
};

@implementation ORIONViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.switchBtns = @[_switchBtn1,_switchBtn2,_switchBtn3];
    self.allSwitchs = @[@[_switchBtn1,_switchBtn2,_switchBtn3]];
    
}

-(void)setSwitchsStateWithType:(OrionSwitchControlType)type{
    
    for (int i=0; i<self.switchBtns.count; i++) {
        NSButton *btn = self.switchBtns[i];
        if (type == OrionSwitchControlTypeProvider) {
            
            btn.state=1;
        }else if(type == OrionSwitchControlTypeOAB){
            
            btn.state=0;
        }
        else if(type == OrionSwitchControlTypeConsumer){
            btn.state = btn.tag==1 ? 0 :1;
        }
        [self setSwitch1BtnImage:btn];
    }
    
}

- (IBAction)orionBtnClick:(NSButton *)switchBtn {
    NSString *btnTitle = switchBtn.title.uppercaseString;
    if ([btnTitle containsString:@"PROVIDER"]) {
        [self setSwitchsStateWithType:OrionSwitchControlTypeProvider];
    }else if ([btnTitle containsString:@"OAB"]){
        [self setSwitchsStateWithType:OrionSwitchControlTypeOAB];
    }else{
        [self setSwitchsStateWithType:OrionSwitchControlTypeConsumer];
    }
    
    [CommandHandler generateCommandWithSwitchBtn:switchBtn text:@"" vcTitle:self.title];
}


- (IBAction)setBtnClick:(NSButton *)switchBtn {
    
    [CommandHandler generateCommandWithSwitchBtn:switchBtn text:self.textF.stringValue vcTitle:self.title];
}



@end
