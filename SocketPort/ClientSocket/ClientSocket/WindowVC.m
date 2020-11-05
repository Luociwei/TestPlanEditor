//
//  WindowVC.m
//  ClientSocket
//
//  Created by ciwei luo on 2020/3/7.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "WindowVC.h"
#import "ViewController.h"
#import "TabVC.h"
@interface WindowVC ()

@end

@implementation WindowVC

- (void)windowDidLoad {
    [super windowDidLoad];
    TabVC *vc = [TabVC new];
    self.contentViewController = vc;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
