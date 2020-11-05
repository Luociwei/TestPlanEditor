//
//  CommandHandler
//  STIM_Pannel
//
//  Created by ciwei luo on 2019/10/17.
//  Copyright © 2019 macdev. All rights reserved.
//

#import "CommandHandler.h"


@interface CommandHandler ()

@end


@implementation CommandHandler

+(NSString *)generateCommandWithSwitchBtn:(NSButton *)switchBtn text:(NSString *)strButtonBlindTextfile vcTitle:title{
    NSString *sPrefix = switchBtn.alternateTitle;
    int nidentifier = switchBtn.tag;
    int nstate=(int)switchBtn.state;
    if (!strButtonBlindTextfile.length) {
        strButtonBlindTextfile=@"N/A";
    }
    
    NSString *cmd =[self graphicToCmd:sPrefix withIdentifier:nidentifier withState:!nstate withTextContent:strButtonBlindTextfile vcTitle:title];
    return cmd;
}


+(NSString *)generateCommandWithPrefix:(NSString *)sPrefix nidentifier:(int)nidentifier nstate:(int)nstate text:(NSString *)strButtonBlindTextfile vcTitle:title{
    NSString *cmd = [self graphicToCmd:sPrefix withIdentifier:nidentifier withState:!nstate withTextContent:strButtonBlindTextfile vcTitle:title];
    return cmd;
}

+(NSString *)graphicToCmd:(NSString *) sPrefix withIdentifier:(int)nidentifier withState:(int)nState withTextContent:(NSString *)buttonText vcTitle:(NSString *)title
{
    
    
    char cmd[255];
    sprintf(cmd, "luadebugpanel.onClickGraphic(\"%s\",%d,%d,\"%s\")",
            [sPrefix cStringUsingEncoding:NSASCIIStringEncoding],
            nidentifier,
            nState,
            [buttonText cStringUsingEncoding:NSASCIIStringEncoding]
            );
    NSLog(@"===click: %s",cmd);
    if ([[NSString stringWithUTF8String:cmd] containsString:@"ORION_IO"])
    {
        return @"";
    }
    
    
    NSDictionary *cmdList=[self getSitmDatas];
    NSString *cmdSend= nil;
    NSString * identifier = [NSString stringWithFormat:@"%04d",nidentifier];
    
    if ([sPrefix isEqualToString:@"BUTTON"])
    {
        if ([[cmdList valueForKey:@"BUTTON"] valueForKey:identifier])
        {
            if (buttonText &&[buttonText isNotEqualTo:@"N/A"])
            {
                NSString *str = [[cmdList valueForKey:@"BUTTON"] valueForKey:identifier];
                buttonText = [buttonText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                cmdSend = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:buttonText];
            }
            
            
        }
        
    }
    else if ([sPrefix isEqualToString:@"MEAS"])
    {
        if ([[cmdList valueForKey:@"MEAS"] valueForKey:identifier])
        {
            NSString *str = [[cmdList valueForKey:@"MEAS"] valueForKey:identifier];
            cmdSend = str;
        }
        
    }
    
    else if ([sPrefix isEqualToString:@"PDMBUTTON"])
    {
        if ([[cmdList valueForKey:@"PDMBUTTON"] valueForKey:identifier])
        {
            NSString *str = [[cmdList valueForKey:@"PDMBUTTON"] valueForKey:identifier];
            cmdSend = str;
        }
        
    }
    
    else if ([sPrefix isEqualToString:@"VBUS"])
    {
        if ([[cmdList valueForKey:@"VBUS"] valueForKey:identifier])
        {
            if (buttonText &&[buttonText isNotEqualTo:@"N/A"])
            {
                NSString *str = [[cmdList valueForKey:@"VBUS"] valueForKey:identifier];
                buttonText = [buttonText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([buttonText intValue]>16000)
                {
                    buttonText = @"16000";
                }
                if ([buttonText intValue]<1221)
                {
                    buttonText = @"1221";
                }
                
                //int ret = ([buttonText intValue] -1221)/4;
                int ret = (5000 -1221)/4;
                cmdSend = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:[NSString stringWithFormat:@"%d",ret]];
            }
            
            
        }
        
    }
    else if ([sPrefix isEqualToString:@"VBUS2"])
    {
        if ([[cmdList valueForKey:@"VBUS2"] valueForKey:identifier])
        {
            if (buttonText &&[buttonText isNotEqualTo:@"N/A"])
            {
                NSString *str = [[cmdList valueForKey:@"VBUS2"] valueForKey:identifier];
                buttonText = [buttonText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([buttonText intValue]>3000)
                {
                    buttonText = @"3000";
                }
                if ([buttonText intValue]<0)
                {
                    buttonText = @"0";
                }
                //                int volt = 5000;
                //                if ([identifier isEqualToString:@"0001"])
                //                {
                //                    volt = 5000;
                //                    int ret = (volt -1221)/4;
                //                    //cmdSend = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:[NSString stringWithFormat:@"%d",ret]];
                //                }
                //                else if ([identifier isEqualToString:@"0002"])
                //                {
                //                    volt = 9000;
                //                }
                //                 else if ([identifier isEqualToString:@"0003"])
                //                {
                //                    volt = 12000;
                //                }
                //                else if ([identifier isEqualToString:@"0004"])
                //                {
                //                    volt = 15000;
                //                }
                
                
                cmdSend = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:[NSString stringWithFormat:@"%@",buttonText]];
            }
            
            
        }
        
    }
    
    else if ([sPrefix isEqualToString:@"VBATT"])
    {
        if ([[cmdList valueForKey:@"VBATT"] valueForKey:identifier])
        {
            if (buttonText &&[buttonText isNotEqualTo:@"N/A"])
            {
                NSString *str = [[cmdList valueForKey:@"VBATT"] valueForKey:identifier];
                buttonText = [buttonText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSLog(@"---VBATT : %@",buttonText);
                cmdSend = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:buttonText];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"krefreshTab" object:nil];
            }
        }
        
    }
    
    else if ([sPrefix isEqualToString:@"ELOAD"])
    {
        if ([[cmdList valueForKey:@"ELOAD"] valueForKey:identifier])
        {
            if (buttonText &&[buttonText isNotEqualTo:@"N/A"])
            {
                NSString *str = [[cmdList valueForKey:@"ELOAD"] valueForKey:identifier];
                buttonText = [buttonText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([buttonText isNotEqualTo:@"0"])
                {
                    cmdSend = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:buttonText];
                }
                else
                {
                    str = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:buttonText];
                    cmdSend = [str stringByReplacingOccurrencesOfString:@"eload enable" withString:@"eload disable"];
                }
                
                // [[NSNotificationCenter defaultCenter]postNotificationName:@"krefreshTab" object:nil];
            }
        }
        
    }
    
    else if([sPrefix isEqualToString:@"IO"])
    {
        NSString *subKey =@"";
        if (nState >0)
        {
            subKey = [NSString stringWithFormat:@"%@_DISCONNECT",identifier];
        }
        else
        {
            subKey = [NSString stringWithFormat:@"%@_CONNECT",identifier];
        }
        
        if ([[cmdList valueForKey:@"IO"] valueForKey:subKey])
        {
            cmdSend = [[cmdList valueForKey:@"IO"] valueForKey:subKey];
        }
        
    }
    else if([sPrefix isEqualToString:@"BIT"])
    {
        NSString *subKey =@"";
        if (nState >0)
        {
            subKey = [NSString stringWithFormat:@"%@_DISCONNECT",identifier];
        }
        else
        {
            subKey = [NSString stringWithFormat:@"%@_CONNECT",identifier];
        }
        
        if ([[cmdList valueForKey:@"IO"] valueForKey:subKey])
        {
            cmdSend = [[cmdList valueForKey:@"IO"] valueForKey:subKey];
        }
        
    }
    else if([sPrefix isEqualToString:@"EXIO"])
    {
        NSString *subKey =@"";
        if (nState >0)
        {
            subKey = [NSString stringWithFormat:@"%@_DISCONNECT",identifier];
        }
        else
        {
            subKey = [NSString stringWithFormat:@"%@_CONNECT",identifier];
        }
        if ([[cmdList valueForKey:@"EXIO"] valueForKey:subKey])
        {
            cmdSend = [[cmdList valueForKey:@"EXIO"] valueForKey:subKey];
        }
        
    }
    else if([sPrefix isEqualToString:@"LED"])
    {
        NSString *subKey =@"";
        if (nState >0)
        {
            subKey = [NSString stringWithFormat:@"%@_DISCONNECT",identifier];
        }
        else
        {
            subKey = [NSString stringWithFormat:@"%@_CONNECT",identifier];
        }
        if ([[cmdList valueForKey:@"LED"] valueForKey:subKey])
        {
            cmdSend = [[cmdList valueForKey:@"LED"] valueForKey:subKey];
        }
        
        
    }
    else if ([sPrefix isEqualToString:@"ORION_SET"])
    {
        if ([[cmdList valueForKey:@"ORION_SET"] valueForKey:identifier])
        {
            if (buttonText &&[buttonText isNotEqualTo:@"N/A"])
            {
                NSString *str = [[cmdList valueForKey:@"ORION_SET"] valueForKey:identifier];
                buttonText = [buttonText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([buttonText isNotEqualTo:@"0"])
                {
                    cmdSend = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:buttonText];
                }
                else
                {
                    str = [str stringByReplacingOccurrencesOfString:@"xxxx" withString:buttonText];
                    cmdSend = [str stringByReplacingOccurrencesOfString:@"eload enable" withString:@"eload disable"];
                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"krefreshTab" object:nil];
            }
        }
        
    }
    
    else if ([sPrefix isEqualToString:@"ORION_BTN"])
    {
        if ([[cmdList valueForKey:@"ORION_BTN"] valueForKey:identifier])
        {
            
            NSString *str = [[cmdList valueForKey:@"ORION_BTN"] valueForKey:identifier];
            cmdSend = str;
        }
    }
    
    else
    {
        
    }
    
    
    NSLog(@"===sendCmd: %@",cmdSend);
    NSString *mutex_identifier = nil;
    if (cmdSend)
    {
        NSArray *cmdArray = [cmdSend componentsSeparatedByString:@"#"];
        if ([cmdArray count]>0)
        {
            cmdSend = cmdArray[0];
        }
        if ([cmdArray count]>1)
        {
            mutex_identifier = cmdArray[1];
        }
        
    }
    
    NSMutableDictionary* dicCmd = [NSMutableDictionary dictionary];
    [dicCmd setValue:cmdSend forKey:Key_SendCmd];
    [dicCmd setValue:title forKey:Key_Title];
    [[NSNotificationCenter defaultCenter] postNotificationName:SendCmdNotification object
                                                              :nil userInfo
                                                              :dicCmd] ;
//@"Send_To_StimCmd"
    return cmdSend;
}


+(NSDictionary *)getSitmDatas{
    NSString *filecmd = [[NSBundle mainBundle] pathForResource:@"StimCmdList_V2" ofType:@"plist"];
    NSDictionary *cmdList =[NSDictionary dictionaryWithContentsOfFile:filecmd];
    return cmdList;
}

+(void)FixtureReset{
    NSDictionary *cmdList = [self getSitmDatas];
    if ([[cmdList valueForKey:@"RESET_ALL"] valueForKey:@"FIXTURERESET"])
    {
        NSMutableDictionary* dicCmd = [NSMutableDictionary dictionary];
        NSString *resetCmds=[[cmdList valueForKey:@"RESET_ALL"] valueForKey:@"FIXTURERESET"];
        [dicCmd setValue:resetCmds forKey:Key_SendCmd];
      
        [[NSNotificationCenter defaultCenter] postNotificationName:SendCmdNotification object
                                                                  :nil userInfo
                                                                  :dicCmd] ;
    }
}



@end
