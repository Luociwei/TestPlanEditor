//
//  OutlineView.m
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/3/3.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "OutlineView.h"
@interface OutlineView() {
    NSColor* backColor;
}
@end
@implementation OutlineView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
//    if (backColor == nil) {
////        float rand_max = RAND_MAX;
////        float red = rand() / rand_max;
////        float green = rand() / rand_max;
////        float blue = rand() / rand_max;
////        backColor = [NSColor colorWithCalibratedRed:100.0 green:200.0 blue:100.0 alpha:1.0];
//
//        backColor = [self colorWithHexColorString:@"d7dde5"];
//    }
//    
//    [backColor set];
//    NSRectFill(self.bounds);

    
    // Drawing code here.
}

- (NSColor*)colorWithHexColorString:(NSString*)inColorString {
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString) {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    
    result = [NSColor
              colorWithCalibratedRed:(CGFloat)redByte / 0xff
              green:(CGFloat)greenByte / 0xff
              blue:(CGFloat)blueByte / 0xff
              alpha:1.0];
    return result;
}
- (id)makeViewWithIdentifier:(NSString *)identifier owner:(id)owner {
    id view = [super makeViewWithIdentifier:identifier owner:owner];
    if ([identifier isEqualToString:NSOutlineViewDisclosureButtonKey]) {
        // Do your customization
        // return disclosure button view
        [view setImage:[NSImage imageNamed:@"Plus"]];
        [view setAlternateImage:[NSImage imageNamed:@"Minus"]];
        [view setBordered:NO];
        [view setTitle:@""];
        return view;
    }
    return view;
}

@end
