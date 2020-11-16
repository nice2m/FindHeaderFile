//
//  ViewController.m
//  FindAllDotHFile
//
//  Created by dftc on 2020/4/30.
//  Copyright © 2020 dftc. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"


@interface ViewController ()

@property (weak) IBOutlet NSTextField *textField;

@property (nonatomic, strong)NSMutableArray * headerFilesList;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = @"查找，归并所有.h 文件";
    _headerFilesList = [NSMutableArray array];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)generateAllFrameworkImportBtnPressed:(NSButton *)sender {
    NSLog(@"generateAllFrameworkImportBtnPressed");
    [self showFilePanelAndGeneratFrameworkDotHFile];
}


#pragma mark - private

- (void)showFilePanelAndGeneratFrameworkDotHFile{
    
    [_headerFilesList removeAllObjects];
    
    [Util showFilePanelSelectComplete:^(NSArray<NSURL *> * _Nonnull urls) {
        [self generateFrameworkDotHFile:urls.firstObject];
    } canceled:^{
        NSLog(@"取消 选择目录");
    }];
}

- (void)generateFrameworkDotHFile:(NSURL *)url{
    self.textField.stringValue = url.absoluteString;

    NSMutableArray <NSString * > *recurisiveFilePathList = [NSMutableArray array];
    [recurisiveFilePathList addObjectsFromArray:[self recusiveFetchPathOfRootPath:url.path]];
    
    // 1. 获取最末路径，设为最末文件名， 即选中的根目录，设置为框架.h 文件名
    
    // 2. 遍历选中目录中获取所有.h文件名
    
    // 3.1 生成 最末文件名.h 文件，#import 所有.h 文件，以便在主工程中导入使用；
    // 3.2 生成.moduleFile 以便Xcode 生成framework 时抽风没有自动生成unbreallamap 文件
    
    // 4.打开文件路径 查看结果

    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    NSString * desPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSDate * date =[NSDate new];
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMdd HHmmss"];
    NSString * dateStr = [formater stringFromDate:date];
    desPath = [NSString stringWithFormat:@"%@/generatedData/%@",desPath,dateStr];
    
    // 生成结果目录
    if (![fileMgr fileExistsAtPath:desPath]){
        NSError * directoryError = nil;
        [fileMgr createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:&directoryError];
        if (directoryError){
            NSLog(@"fatle error:%@",directoryError);
            return;
        }
    }
    
    // 1.
    NSArray <NSString *> * lastComps = [self.textField.stringValue componentsSeparatedByString:@"/"];
    NSString * lastComponents = lastComps[lastComps.count - 2];
    
    // 2.
    NSMutableArray <NSString *> * tmpRt = [NSMutableArray array];
    [recurisiveFilePathList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSString *> * fileNames = [obj componentsSeparatedByString:@"/"];
        NSString * fileName = [fileNames lastObject];
        
        // 不引入与工程名同名的.h 文件，否则生成frame 报错
        if ([fileName isEqualTo: lastComponents]){}else{
            [tmpRt addObject:fileName];
        }
    }];
    
    // 3.1
    
    NSString * dotHDateStr = [NSString stringWithFormat:@"//\n\n//%@\n\n",dateStr];
    
    NSString * dotHHeader = [NSString stringWithFormat:@"#ifdef __OBJC__\n\n#import <Foundation/Foundation.h>\n//! Project version number for %@.\nFOUNDATION_EXPORT double %@VersionNumber;\n//! Project version string for %@.\nFOUNDATION_EXPORT const unsigned char %@VersionString[];\n\n",lastComponents,lastComponents,lastComponents,lastComponents];
    
    NSMutableString * contentString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@",dotHDateStr,dotHHeader]];
    [tmpRt enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * anImport = [NSString stringWithFormat:@"\n#import <%@/%@>\n",lastComponents,obj];
        [contentString appendString:anImport];
    }];
    NSString * tailString = @"\n\n#endif";
    [contentString appendString:tailString];
    
    // 写入文件
    NSString * rtFileName = [NSString stringWithFormat:@"%@.h",lastComponents];
    
    NSString * headerFilePath = [NSString stringWithFormat:@"%@/%@",desPath,rtFileName];
    NSError * fileError = nil;
    
    [contentString writeToFile:headerFilePath atomically:YES encoding:NSUTF8StringEncoding error:&fileError];
    if (fileError){
        NSLog(@"fattle error:文件%@\t写入失败 \n%@",rtFileName,fileError);
    }
    else{
        NSLog(@"文件写入成功 \n%@",headerFilePath);
    }
    
    // 3.2
    /*
     framework module TckkFrameworks {
         umbrella header "TckkFrameworks.h"
         export *
         module * { export * }
     }
     */
    NSString * moduleFileString = [NSString stringWithFormat:@"framework module %@ {\n\tumbrella header \"%@.h\"\n\texport *\n\tmodule * { export * }\n}",lastComponents,lastComponents];
    NSString * moduleFileName = [NSString stringWithFormat:@"%@.modulemap",lastComponents];
    NSString * moduleFilePath = [NSString stringWithFormat:@"%@/%@",desPath,moduleFileName];
    NSError * moduleError = nil;
    [moduleFileString writeToFile:moduleFilePath atomically:YES encoding:NSUTF8StringEncoding error:&moduleError];
    if (fileError){
        NSLog(@"fattle error:文件%@\t写入失败 \n%@",moduleFileName,fileError);
    }
    else{
        NSLog(@"文件写入成功 \n%@",moduleFileName);
    }
    
    //4.
    NSURL *fileURL = [NSURL fileURLWithPath: desPath];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[fileURL]];
}

// 遍历查找rootPath下所有.h 文件
- (NSArray <NSString *> *)recusiveFetchPathOfRootPath:(NSString *)rootPath{
    
    NSMutableArray * rt = [NSMutableArray array];
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator * enumerator = [fileMgr enumeratorAtPath:rootPath];
    for (NSString * path in enumerator) {
        BOOL isPath = NO;
        [fileMgr fileExistsAtPath:path isDirectory:&isPath];
        if (isPath){
        }
        // 测试是否.h 文件
        BOOL isHeaderFile = [path hasSuffix:@".h"];
        if (isHeaderFile){
            [rt addObject:[NSString stringWithFormat:@"%@/%@",rootPath,path]];
        }
    }
    return rt;
}

@end

