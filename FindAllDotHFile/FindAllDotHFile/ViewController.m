//
//  ViewController.m
//  FindAllDotHFile
//
//  Created by dftc on 2020/4/30.
//  Copyright © 2020 dftc. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"
#import "MessageUI.h"
#import "MainCooker.h"


@interface ViewController ()

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSButton *btn;

@property (nonatomic, strong)NSMutableArray * headerFilesList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = @"查找，合并所有.h 文件";
    _headerFilesList = [NSMutableArray array];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)generateAllFrameworkImportBtnPressed:(NSButton *)sender {
    NSLog(@"generateAllFrameworkImportBtnPressed");
    sender.enabled = false;
    
    [self showFilePanelAndGeneratFrameworkDotHFile];
}

#pragma mark - private

- (void)showFilePanelAndGeneratFrameworkDotHFile{
    
    __weak typeof(self) weakSelf = self;
    
    [_headerFilesList removeAllObjects];
    [Util showFilePanelSelectComplete:^(NSArray<NSURL *> * _Nonnull urls) {
        [self generateFrameworkDotHFile:urls.firstObject complete:^(BOOL succeed) {
            weakSelf.btn.enabled = true;
        }];
    } canceled:^{
        NSLog(@"取消 选择目录");
        self.btn.enabled = true;
    }];
}

- (void)generateFrameworkDotHFile:(NSURL *)url complete:(void(^)(BOOL succeed))complete{
    
    self.textField.stringValue = url.absoluteString;
    
    NSURL * distURL = [MainCooker generateFrameworkWithRootPathURL:url];
    
    if (!distURL) {
        [MessageUI showMsg:@"生成Header 文件失败，详细阅读教程"];
        complete(false);
        return ;
    };
    
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[distURL]];
    complete(true);
}


@end

