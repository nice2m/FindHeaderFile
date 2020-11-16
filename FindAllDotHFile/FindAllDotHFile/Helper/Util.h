//
//  Util.h
//  FindAllDotHFile
//
//  Created by dftc on 2020/9/21.
//  Copyright © 2020 dftc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Util : NSObject

+ (void)showFilePanelSelectComplete:(void(^)(NSArray <NSURL *> *urls))completed canceled:(void(^)(void))canceled;

@end

NS_ASSUME_NONNULL_END
