//
//  BaseViewController.h
//  FindAllDotHFile
//
//  Created by dftc on 2020/9/11.
//  Copyright © 2020 dftc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseViewController <NSObject>

+ (NSString *)titleName;

+ (NSString *)funcDes;

@end

NS_ASSUME_NONNULL_END
