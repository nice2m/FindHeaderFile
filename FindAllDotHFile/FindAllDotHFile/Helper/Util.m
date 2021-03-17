//
//  Util.m
//  FindAllDotHFile
//
//  Created by dftc on 2020/9/21.
//  Copyright © 2020 dftc. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "Util.h"

@implementation Util

+ (void)showFilePanelSelectComplete:(void (^)(NSArray<NSURL *> * _Nonnull urls))completed canceled:(void (^)(void))canceled{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    // yes if more than one dir is allowed
    [panel setAllowsMultipleSelection:NO];
    NSInteger clicked = [panel runModal];

    NSMutableArray <NSURL *> *rt = [NSMutableArray array];
    if (clicked == NSModalResponseCancel){
        canceled();
        return;
    }
    for (NSURL *url in [panel URLs]) {
        // do something with the url here.
        [rt addObject:url];
    }
    completed(rt);
}

@end
