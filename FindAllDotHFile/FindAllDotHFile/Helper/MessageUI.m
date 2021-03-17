//
//  MessageUI.m
//  FindAllDotHFile
//
//  Created by dftc on 2020/9/11.
//  Copyright © 2020 dftc. All rights reserved.
//

#import "MessageUI.h"
#import <Cocoa/Cocoa.h>


@implementation MessageUI

+ (void)showMsg: (NSString *)msg{
    NSAlert * alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleInformational;
    alert.messageText = msg ;
    [alert addButtonWithTitle:@"OK"];

    [alert runModal];
}

@end
