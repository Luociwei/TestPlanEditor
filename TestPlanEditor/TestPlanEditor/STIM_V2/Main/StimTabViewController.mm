//
//  StimTabViewController
//  STIM_Pannel
//
//  Created by ciwei luo on 2019/10/17.
//  Copyright © 2019 macdev. All rights reserved.
//



#import "StimTabViewController.h"
#import "ELoadViewController.h"
#import "DMICViewController.h"
#import "ResAudioViewController.h"
#import "ORIONViewController.h"
#import "PowerViewController.h"
#import "RigelViewController.h"
#import "NTCViewController.h"
#import "ButtonPressViewController.h"
#import "DischargeViewController.h"
#import "DutController.h"
#import "RegexKitLite.h"
#import "STIMBaseViewController.h"

@interface StimTabViewController ()
@property (nonatomic,strong) NSTextField *measurementLable;
@end


@implementation StimTabViewController
{
    CDUTController * pDUT;
    NSString *gainValue;
    NSString *nameAIMeas;
    NSString *nameAIUnit;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDutController];
    [self setUPChildVC:[ELoadViewController new]];
    [self setUPChildVC:[DMICViewController new]];
    [self setUPChildVC:[ResAudioViewController new]];
    [self setUPChildVC:[ORIONViewController new]];
    [self setUPChildVC:[PowerViewController new]];
    [self setUPChildVC:[RigelViewController new]];
     [self setUPChildVC:[NTCViewController new]];
    [self setUPChildVC:[ButtonPressViewController new]];
    [self setUPChildVC:[DischargeViewController new]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SendCmdToXavier:) name:SendCmdNotification object:nil];
   
}

-(void)SendCmdToXavier:(NSNotification*)nf
{

    NSDictionary *userInfo = [nf userInfo];
    NSString *title =[userInfo objectForKey:Key_Title];
    STIMBaseViewController *vc = [self getVCWithTitle:title];
    if (vc !=nil) {
        
        self.measurementLable = vc.m_measurment;
    }
    NSString *cmd =[userInfo objectForKey:Key_SendCmd];
    self.measurementLable.stringValue = cmd;
    if (cmd.length) {
        [self sendCmd:cmd];
    }


//    if ([userInfo objectForKey:kSendCmd])
//    {
//        NSString * cmd = [userInfo objectForKey:kSendCmd];
//        [comboxCmd setStringValue:cmd];
//        [self btSend:nil];
//    }
//    else
//    {
//        [comboxCmd setStringValue:@"nil"];
//    }
    
}
-(void)setUPChildVC:(STIMBaseViewController *)vc{
    
    NSString *title = NSStringFromClass([vc class]);
    vc.title = title;
    
    if ([title containsString:@"ViewController"]) {
        NSRange range = [title rangeOfString:@"ViewController"];
        vc.title = [title substringToIndex:range.location];
    }
    
    [self addChildViewController:vc];
}

-(STIMBaseViewController *)getVCWithTitle:(NSString *)title{
    if (title.length) {
        for (STIMBaseViewController *vc in self.childViewControllers) {
            if ([vc.title.lowercaseString containsString:title.lowercaseString]) {
                return vc;
            }
        }
    }

    return nil;
}

-(void)setDutController{
    pDUT = new CDUTController();
    pDUT->SetDelegate(self);
    pDUT->Close();
    pDUT->Initial([@"tcp://127.0.0.1:7600" UTF8String], [@"tcp://127.0.0.1:7650" UTF8String]);
}


-(void)sendCmd:(NSString *)command{
    
    if (!command.length)
    {
        return;
    }
    
    NSMutableString * cmds = [NSMutableString string];
    [cmds appendString:command];
    
    NSArray *arrayCmd = [cmds componentsSeparatedByString:@";"];
    [DebugLog saveLogToDefaultFileWithContent:[NSString stringWithFormat:@"send command:%@",cmds] fileName:self.title];
    NSMutableString * cmd = [NSMutableString string];
    for (NSString *sub_cmd in arrayCmd)
    {
        // [self saveLogWithContent:[NSString stringWithFormat:@"send command:%@",sub_cmd]];
        
        [DebugLog saveLogToDefaultFileWithContent:[NSString stringWithFormat:@"send command:%@",sub_cmd] fileName:self.title];
        if ([sub_cmd containsString:@"delay"])
        {
            NSString *regexStr = @"delay\\s*([0-9]{1,}[.]?[0-9]*)";
            NSString *matchedStr = [sub_cmd stringByMatching:regexStr capture:1L];
            if(matchedStr)
            {
                [NSThread sleepForTimeInterval:[matchedStr floatValue]];
            }
        }
        
        else if ([sub_cmd containsString:@"["] && [sub_cmd containsString:@"]"])
        {
            
            
            [cmd setString:sub_cmd];
            [cmd appendString:@"\r\n"];
            
            int ret = pDUT->WriteString([cmd UTF8String]);
            if (ret<0)
            {
                [DebugLog saveLogToDefaultFileWithContent:@"Exit...not connect.." fileName:self.title];
                NSAlert * alert = [[NSAlert alloc] init];
                alert.messageText = [NSString stringWithFormat:@"Write DUT failed"];
                alert.informativeText = @"Replier not response,Please make sure TestEngine is running...";
                [alert runModal];
                [alert release];
                return;
            }
            [NSThread sleepForTimeInterval:0.01];
            NSLog(@"---cmd: %@",cmd);
            
            
        }
        else
        {
            //NSLog(@"-->sub_cmd: %@",sub_cmd);
            
            //            NSMutableDictionary* dicCmd = [NSMutableDictionary dictionary];
            //            [dicCmd setValue:sub_cmd forKey:kSendDUTCmd];
            //            NSLog(@"==diags=>: %@",dicCmd);
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDUTCmd object
            //                                                                      :nil userInfo
            //                                                                      :dicCmd] ;
            //            [NSThread sleepForTimeInterval:0.01];
        }
    }
}
-(void)dealloc{
    [super dealloc];
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    pDUT->Close();
    
    if (pDUT)
    {
        delete pDUT;
        pDUT = nullptr;
    }
}
-(void)OnData:(void *)bytes length:(long)len
{
    if (!len) return;
    NSLog(@"OnData len:%ld",len);
    if (len < 1) return;
    NSString * str;
    
    if ( (str= [[NSString alloc] initWithBytes:bytes length:len encoding:NSUTF8StringEncoding]) == nil)
    {
        NSLog(@"OnData bytes:nil");
        return;
    }
    
    NSLog(@"str:%@",str);
    NSString *str1 = [NSString stringWithString:str];
    str1 = [self ReplaceTimeStamp:str1];
    //    self.resultString = str1;
    
    [DebugLog saveLogToDefaultFileWithContent:[NSString stringWithFormat:@"response:%@",str1] fileName:self.title];
    
    NSLog(@"str1:%@",str1);
    [self performSelectorOnMainThread:@selector(OnLog:)  withObject:str1 waitUntilDone:NO];
    [str release];
}


#define TIME_STAMP_MATCH        @"[0-9A-Fa-f]+@R\\d"
#define TIME_STAMP_MATCH_CAP    @"([0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])([0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])@R\\d"
-(NSString *)ReplaceTimeStamp:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfRegex:TIME_STAMP_MATCH options:RKLMultiline inRange:NSMakeRange(0, [str length]-1) error:nil enumerationOptions:RKLRegexEnumerationNoOptions usingBlock:^NSString *(NSInteger captureCount, NSString *const *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        NSString * cap = [NSString stringWithString:(NSString *)*capturedStrings];
        NSString * strSecond = [cap stringByMatching:TIME_STAMP_MATCH_CAP capture:1];
        NSString * strMS = [cap stringByMatching:TIME_STAMP_MATCH_CAP capture:2];
        if ((!str)||(!strMS)) {
            return @"";
        }
        
        long seconds = strtol([[@"0x" stringByAppendingString:strSecond] UTF8String], NULL, 16);
        long ms = strtol([[@"0x" stringByAppendingString:strMS] UTF8String], NULL, 16);
        NSTimeInterval time = seconds+(double)ms/1000.0;
        
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss.SSS : "];
        
        NSString * rep = [dateFormatter stringFromDate:date];
        
        [dateFormatter release];
        return rep;
        
    }];
}



-(void)OnLog:(NSString *)str
{
    if (!str) return;
    
    //  NSMutableString * pstr = [[txtBuffer textStorage] mutableString];
    //    if ([str containsString:@"\n"])
    //    {
    //        [pstr appendFormat:@"%@",str];
    //    }
    //    else
    //    {
    //        [pstr appendFormat:@"%@\n",str];
    //    }
    //  NSMutableString *mutString= [NSMutableString stringWithString:str];
    if ([str containsString:@"[444555666]"]&&([str containsString:@"ACK"]))
    {
        //  [m_measurment setStringValue:@""];
        NSString *regexStr = @"ACK\\s*\\(\\s*([+-]?[0-9]{1,}[.]?[0-9]*)";
        NSString *matchedStr = [str stringByMatching:regexStr capture:1L];
        if(matchedStr)
        {
            
            NSString *strItem = @"";
            if ([matchedStr doubleValue]>5)
            {
                strItem = [NSString stringWithFormat:@"%@:%f %@",nameAIMeas, [matchedStr doubleValue]*[gainValue doubleValue],nameAIUnit];
                
            }
            else
            {
                strItem = [NSString stringWithFormat:@"%@:%f %@",nameAIMeas, [matchedStr doubleValue],nameAIUnit];
            }
            
            
            self.measurementLable.stringValue=strItem;
            
        }
        else
        {
            
            [self.measurementLable setStringValue:[NSString stringWithFormat:@"%@:NULL %@",nameAIMeas,nameAIUnit]];
            
        }
        
    }
    else if ([str containsString:@"[555666777]"]&&([str containsString:@"ACK"]))
    {
        NSString *regexStr = @"ACK\\s*\\(\\s*([+-]?[0-9]{1,}[.]?[0-9]*)";
        NSString *matchedStr = [str stringByMatching:regexStr capture:1L];
        NSString *strValue = [NSString stringWithFormat:@"%f",[matchedStr doubleValue]*[gainValue doubleValue]];
        self.measurementLable.stringValue=[NSString stringWithFormat:@"Measure Result:%@",strValue];
        //        [mutString appendString:[NSString stringWithFormat:@"measurementValue2:%@",matchedStr]];
        
        //        NSMutableDictionary* dicCmd = [NSMutableDictionary dictionary];
        //        [dicCmd setValue:matchedStr forKey:@"measurement"];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"getMeasurementValue" object
        //                                                                  :nil userInfo
        //                                                                  :dicCmd] ;
        
    }
    else if ([str containsString:@"[777999888]"]&&([str containsString:@"ACK"]))
    {
        
    }
    // NSRange range = NSMakeRange([pstr length]-1,0);
    // [txtBuffer scrollRangeToVisible:range];
    // [self.showingLabel setStringValue:mutString];
    
}


@end
