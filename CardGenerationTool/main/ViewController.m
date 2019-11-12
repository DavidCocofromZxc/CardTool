//
//  ViewController.m
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/10.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "ViewController.h"
#import "ExhibitionView.h"
@interface ViewController()<urlDelegate>

@property (weak) IBOutlet NSTextField *bgPathTextField;
@property (weak) IBOutlet ExhibitionView *bgView;

@property (weak) IBOutlet NSTextField *leftupTextField;
@property (weak) IBOutlet ExhibitionView *leftupView;
@property (weak) IBOutlet NSTextField *rightupTextField;
@property (weak) IBOutlet ExhibitionView *rightupView;
@property (weak) IBOutlet NSTextField *leftdownTextField;
@property (weak) IBOutlet ExhibitionView *leftdownView;
@property (weak) IBOutlet NSTextField *rightdownTextField;
@property (weak) IBOutlet ExhibitionView *rightdownView;
@property (weak) IBOutlet NSImageView *previewView;//预览
//
@property (weak) IBOutlet NSTextField *textView;

@property (nonatomic,strong) NSImage *bgimage;
@property (nonatomic,strong) NSImage *leftupimage;
@property (nonatomic,strong) NSImage *leftdownimage;
@property (nonatomic,strong) NSImage *rightupimage;
@property (nonatomic,strong) NSImage *rightdownimage;

@property (weak) IBOutlet NSTextField *tfScPath;
@property (weak) IBOutlet NSTextField *tfSavePath;


@property (nonatomic,strong) NSArray *urlList;


@end
@implementation ViewController

- (void)viewDidAppear;{
    //搜索操作记录
    [self searchOperationalRecords];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previewView.wantsLayer = YES;
    self.previewView.layer.borderWidth = 1.f;
    self.previewView.layer.borderColor = NSColor.grayColor.CGColor;
    
    self.bgView.key = @"bg";
    self.leftupView.key = @"A";
    self.rightupView.key = @"B";
    self.leftdownView.key = @"C";
    self.rightdownView.key = @"D";
    
    self.bgView.delegate = self;
    self.leftupView.delegate = self;
    self.rightupView.delegate = self;
    self.leftdownView.delegate = self;
    self.rightdownView.delegate = self;
    
    [self addObserber];
    //
    [self textFieldHandle];
    
    
    
    //还原上次的地址
    NSString *scPath = [[NSUserDefaults standardUserDefaults] objectForKey:TARGET_FOLDER_PATH];
    NSString *savePath = [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_FOLDER_PATH];
    scPath = scPath?scPath:@"";
    self.tfScPath.stringValue = scPath;
    savePath = savePath?savePath:@"";
    self.tfSavePath.stringValue = savePath;
    
    //还原上次记录的位置
    NSString *frameleftup = [[NSUserDefaults standardUserDefaults] objectForKey:FRAME_A];
    NSString *frameleftdown = [[NSUserDefaults standardUserDefaults] objectForKey:FRAME_C];
    NSString *framerightup = [[NSUserDefaults standardUserDefaults] objectForKey:FRAME_B];
    NSString *framerightdown = [[NSUserDefaults standardUserDefaults] objectForKey:FRAME_D];
    if(frameleftup){
        NSRect frame = NSRectFromString(frameleftup);
        self.leftupView.frame = frame;
    }else{
        self.leftupView.frame = CGRectMake(self.bgView.frame.origin.x + 30 * 0,
                                           self.bgView.frame.origin.y,
                                           30,
                                           30);
    }
    if(frameleftdown){
        NSRect frame = NSRectFromString(frameleftdown);
        self.leftdownView.frame = frame;
    }else{
        self.leftdownView.frame = CGRectMake(self.bgView.frame.origin.x + 30 * 2,
                                             self.bgView.frame.origin.y,
                                             30,
                                             30);
    }
    if(framerightup){
        NSRect frame = NSRectFromString(framerightup);
        self.rightupView.frame = frame;
    }else{
        self.rightupView.frame = CGRectMake(self.bgView.frame.origin.x + 30 * 1,
                                            self.bgView.frame.origin.y,
                                            30,
                                            30);
    }
    if(framerightdown){
        NSRect frame = NSRectFromString(framerightdown);
        self.rightdownView.frame = frame;
    }else{
        self.rightdownView.frame = CGRectMake(self.bgView.frame.origin.x + 30 * 3,
                                              self.bgView.frame.origin.y,
                                              30,
                                              30);
    }
}


- (void)viewWillDisappear;{
    [self removeObserber];
}

- (void)addObserber;{
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:DIRECTORY_ADDRESS_BG
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:DIRECTORY_ADDRESS_A
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:DIRECTORY_ADDRESS_C
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:DIRECTORY_ADDRESS_B
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:DIRECTORY_ADDRESS_D
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
}

- (void)removeObserber;{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:DIRECTORY_ADDRESS_BG];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:DIRECTORY_ADDRESS_A];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:DIRECTORY_ADDRESS_C];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:DIRECTORY_ADDRESS_B];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:DIRECTORY_ADDRESS_D];
}

//实现监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    WeakSelf
    if ([keyPath isEqual:DIRECTORY_ADDRESS_BG]) {
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_BG];
        if( path && ![path isEqualToString:@""]){
            [[FileManager sharedInstance] queryFile:path success:^(NSFileManager * _Nonnull manager){
                NSImage *img = [[NSImage alloc]initWithContentsOfFile:path];
                weakSelf.bgimage = img;
            } fail:^(NSFileManager * _Nonnull manager) {
                [[AlertManager sharedInstance] showWarnAlert:self.view
                                                       title:@""
                                                        text:@"目标文件已被移除或已损坏"];
                weakSelf.bgPathTextField.stringValue = @"";
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_BG];
            }];
        };
    }
    if ([keyPath isEqual:DIRECTORY_ADDRESS_A]) {
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_A];
        if( path && ![path isEqualToString:@""]){
            [[FileManager sharedInstance] queryFile:path success:^(NSFileManager * _Nonnull manager){
                NSImage *img = [[NSImage alloc]initWithContentsOfFile:path];
                weakSelf.leftupimage = img;
            } fail:^(NSFileManager * _Nonnull manager) {
                [[AlertManager sharedInstance] showWarnAlert:self.view
                                                       title:@""
                                                        text:@"目标文件已被移除或已损坏"];
                weakSelf.leftupTextField.stringValue = @"";
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_A];
            }];
        };
    }
    if ([keyPath isEqual:DIRECTORY_ADDRESS_C]) {
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_C];
        if( path && ![path isEqualToString:@""]){
            [[FileManager sharedInstance] queryFile:path success:^(NSFileManager * _Nonnull manager){
                NSImage *img = [[NSImage alloc]initWithContentsOfFile:path];
                weakSelf.leftdownimage = img;
            } fail:^(NSFileManager * _Nonnull manager) {
                [[AlertManager sharedInstance] showWarnAlert:self.view
                                                       title:@""
                                                        text:@"目标文件已被移除或已损坏"];
                weakSelf.leftdownTextField.stringValue = @"";
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_C];
            }];
        };
    }
    if ([keyPath isEqual:DIRECTORY_ADDRESS_B]) {
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_B];
        if( path && ![path isEqualToString:@""]){
            [[FileManager sharedInstance] queryFile:path success:^(NSFileManager * _Nonnull manager){
                NSImage *img = [[NSImage alloc]initWithContentsOfFile:path];
                weakSelf.rightdownimage = img;
            } fail:^(NSFileManager * _Nonnull manager) {
                [[AlertManager sharedInstance] showWarnAlert:self.view
                                                       title:@""
                                                        text:@"目标文件已被移除或已损坏"];
                weakSelf.rightdownTextField.stringValue = @"";
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_B];
            }];
        };
    }
    if ([keyPath isEqual:DIRECTORY_ADDRESS_D]) {
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_D];
        if( path && ![path isEqualToString:@""]){
            [[FileManager sharedInstance] queryFile:path success:^(NSFileManager * _Nonnull manager){
                NSImage *img = [[NSImage alloc]initWithContentsOfFile:path];
                weakSelf.rightupimage = img;
            } fail:^(NSFileManager * _Nonnull manager) {
                [[AlertManager sharedInstance] showWarnAlert:self.view
                                                       title:@""
                                                        text:@"目标文件已被移除或已损坏"];
                weakSelf.rightupTextField.stringValue = @"";
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_D];
            }];
        };
    }
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma -mark other
//选取素材文件
- (IBAction)selectFile:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];//是否能选择文件file
    [panel setCanChooseDirectories:YES];//是否能打开文件夹
    NSInteger finded = [panel runModal]; //获取panel的响应
    NSLog(@"%ld",finded);
    if(finded == NSModalResponseOK){
        NSString *url = [panel URLs].firstObject.description;
        NSString *chineseUrl = [url stringByRemovingPercentEncoding];
        NSString *useUrl = [chineseUrl stringByReplacingOccurrencesOfString:@"file://"
                                                                  withString:@""];
        self.tfScPath.stringValue = useUrl;
        [[NSUserDefaults standardUserDefaults] setObject:useUrl forKey:TARGET_FOLDER_PATH];
    }
}
//选取
- (IBAction)savePathFileSelect:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];//是否能选择文件file
    [panel setCanChooseDirectories:YES];//是否能打开文件夹
    NSInteger finded = [panel runModal]; //获取panel的响应
    NSLog(@"%ld",finded);    
    if(finded == NSModalResponseOK){
        NSString *url = [panel URLs].firstObject.description;
        NSString *chineseUrl = [url stringByRemovingPercentEncoding];
        NSString *useUrl = [chineseUrl stringByReplacingOccurrencesOfString:@"file://"
                                                                  withString:@""];
        self.tfSavePath.stringValue = useUrl;
        [[NSUserDefaults standardUserDefaults] setObject:useUrl forKey:SAVE_FOLDER_PATH];
    }
}

//执行
- (IBAction)saveImage:(id)sender {
    //默认
    NSString *name = @"test.png";
    NSString *path = [NSString stringWithFormat:@"%@%@",FILE_SAVE_PATH,name];
    
    //保存路径
    if(![self.tfSavePath.stringValue isEqualToString:@""]){
        path = [NSString stringWithFormat:@"%@%@",self.tfSavePath.stringValue,name];
    }
    //素材路径
    if(![self.tfScPath.stringValue isEqualToString:@""]){
        NSArray *urlList = [self getFiles:self.tfScPath.stringValue];
        NSInteger ii = 0;
        for (NSString *url in urlList) {
            NSImage *img = [[NSImage alloc]initWithContentsOfFile:url];
            NSImage *comImage = [self imageComPleteImage:img];
            path = [NSString stringWithFormat:@"%@%ld%@",self.tfSavePath.stringValue,ii,name];
            [ZLImage saveImage:comImage fileName:path];
            ii++;
        }
    }else{//保存操作
        NSLog(@"%@", [ZLImage saveImage:self.previewView.image fileName:path]?@"save successful":@"save fail");
    }
}

//预览Action
- (IBAction)showCompleteImage:(id)sender {
    [self.previewView setImage:[self imageComPleteImage:self.bgimage]];
}

- (NSImage *)imageComPleteImage:(NSImage *)bgImage;{//:(NSArray <CGTImage *>*)imagelist;{
    
        CGSize conSize = NSMakeSize(30, 30);
        //获取记录的位置
        CGRect luframe = NSRectFromString([[NSUserDefaults standardUserDefaults]objectForKey:FRAME_A]);
        CGRect ldframe = NSRectFromString([[NSUserDefaults standardUserDefaults]objectForKey:FRAME_C]);
        CGRect ruframe = NSRectFromString([[NSUserDefaults standardUserDefaults]objectForKey:FRAME_B]);
        CGRect rdframe = NSRectFromString([[NSUserDefaults standardUserDefaults]objectForKey:FRAME_D]);
        //计算居中时产生的缝隙差
        CGPoint bgPoint = [ZLImage getCenteredDisplayPointInSize:CARD_SIZE withSize:self.bgimage.size];
        CGPoint leftupPoint = [ZLImage getCenteredDisplayPointInSize:conSize withSize:self.leftupimage.size];
        CGPoint leftdownPoint = [ZLImage getCenteredDisplayPointInSize:conSize withSize:self.leftupimage.size];
        CGPoint rightupiPoint = [ZLImage getCenteredDisplayPointInSize:conSize withSize:self.rightupimage.size];
        CGPoint rightdowniPoint = [ZLImage getCenteredDisplayPointInSize:conSize withSize:self.rightupimage.size];
    
        //计算实际值
        //记录值 + 产生缝隙 -bgView在Frame中的位置
        leftupPoint = CGPointMake(luframe.origin.x + leftupPoint.x - self.bgView.frame.origin.x ,
                                  luframe.origin.y + leftupPoint.y - self.bgView.frame.origin.y);
        leftdownPoint = CGPointMake(ldframe.origin.x + leftdownPoint.x -self.bgView.frame.origin.x,
                                    ldframe.origin.y + leftdownPoint.y -self.bgView.frame.origin.y);
        rightupiPoint = CGPointMake(ruframe.origin.x + rightupiPoint.x  -self.bgView.frame.origin.x,
                                    ruframe.origin.y + rightupiPoint.y -self.bgView.frame.origin.y);
        rightdowniPoint = CGPointMake(rdframe.origin.x + rightdowniPoint.x -self.bgView.frame.origin.x ,
                                      rdframe.origin.y + rightdowniPoint.y -self.bgView.frame.origin.y);
        //
        CGTImage *bgimage = [[CGTImage alloc]initImage:bgImage x:bgPoint.x y:bgPoint.y];
        CGTImage *leftupimage = [[CGTImage alloc]initImage:self.leftupimage x:leftupPoint.x y:leftupPoint.y];
        CGTImage *leftdownimage = [[CGTImage alloc]initImage:self.leftdownimage x:leftdownPoint.x y:leftdownPoint.y];
        CGTImage *rightupimage = [[CGTImage alloc]initImage:self.rightupimage x:rightupiPoint.x y:rightupiPoint.y];
        CGTImage *rightdownimage = [[CGTImage alloc]initImage:self.rightdownimage x:rightdowniPoint.x y:rightdowniPoint.y];
        NSArray *imagelist = [NSArray arrayWithObjects:bgimage,leftupimage,leftdownimage,rightupimage,rightdownimage,nil];
        //拼接
        return [ZLImage completeImages:imagelist];
}



- (void)searchOperationalRecords;{
    WeakSelf
    //bg
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_BG];
    if( path && ![path isEqualToString:@""]){
        [[FileManager sharedInstance] queryFile:path success:^(NSFileManager * _Nonnull manager){
            NSImage *img = [[NSImage alloc]initWithContentsOfFile:path];
            weakSelf.bgimage = img;
            [weakSelf.bgView setImage:img];
            weakSelf.bgPathTextField.stringValue = path;
        } fail:^(NSFileManager * _Nonnull manager) {
            [[AlertManager sharedInstance] showWarnAlert:self.view
                                                   title:@""
                                                    text:@"目标文件已被移除或已损坏"];
            weakSelf.bgPathTextField.stringValue = @"";
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_BG];
        }];
    };
    //leftup
    NSString *path2 = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_A];
    if( path2 && ![path2 isEqualToString:@""]){
        [[FileManager sharedInstance] queryFile:path2 success:^(NSFileManager * _Nonnull manager){
            NSImage *img = [[NSImage alloc]initWithContentsOfFile:path2];
            weakSelf.leftupimage = img;
            [weakSelf.leftupView setImage:img];
            weakSelf.leftupTextField.stringValue = path2;
        } fail:^(NSFileManager * _Nonnull manager) {
            [[AlertManager sharedInstance] showWarnAlert:self.view
                                                   title:@""
                                                    text:@"目标文件已被移除或已损坏"];
            weakSelf.leftupTextField.stringValue = @"";
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_A];
        }];
    };
    NSString *path3 = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_C];
    if( path3 && ![path3 isEqualToString:@""]){
        [[FileManager sharedInstance] queryFile:path3 success:^(NSFileManager * _Nonnull manager){
            NSImage *img = [[NSImage alloc]initWithContentsOfFile:path3];
            weakSelf.leftdownimage = img;
            [weakSelf.leftdownView setImage:img];
            weakSelf.leftdownTextField.stringValue = path3;
        } fail:^(NSFileManager * _Nonnull manager) {
            [[AlertManager sharedInstance] showWarnAlert:self.view
                                                   title:@""
                                                    text:@"目标文件已被移除或已损坏"];
            weakSelf.leftdownTextField.stringValue = @"";
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_C];
        }];
    };
    NSString *path4 = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_B];
    if( path4 && ![path4 isEqualToString:@""]){
        [[FileManager sharedInstance] queryFile:path4 success:^(NSFileManager * _Nonnull manager){
            NSImage *img = [[NSImage alloc]initWithContentsOfFile:path4];
            weakSelf.rightdownimage = img;
            [weakSelf.rightdownView setImage:img];
            weakSelf.rightdownTextField.stringValue = path4;
        } fail:^(NSFileManager * _Nonnull manager) {
            [[AlertManager sharedInstance] showWarnAlert:self.view
                                                   title:@""
                                                    text:@"目标文件已被移除或已损坏"];
            weakSelf.rightdownTextField.stringValue = @"";
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_B];
        }];
    };
    NSString *path5 = [[NSUserDefaults standardUserDefaults] objectForKey:DIRECTORY_ADDRESS_D];
    if( path5 && ![path5 isEqualToString:@""]){
        [[FileManager sharedInstance] queryFile:path5 success:^(NSFileManager * _Nonnull manager){
            NSImage *img = [[NSImage alloc]initWithContentsOfFile:path5];
            weakSelf.rightupimage = img;
            [weakSelf.rightupView setImage:img];
            weakSelf.rightupTextField.stringValue = path5;
        } fail:^(NSFileManager * _Nonnull manager) {
            [[AlertManager sharedInstance] showWarnAlert:self.view
                                                   title:@"" 
                                                    text:@"目标文件已被移除或已损坏"];
            weakSelf.rightupTextField.stringValue = @"";
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:DIRECTORY_ADDRESS_D];
        }];
    };
}

#pragma -mark urlDelegate
- (void)receiveUrlMessage:(NSString *)url key:(NSString *)key;{
    [[NSUserDefaults standardUserDefaults] setObject:url
                                              forKey:[@"DirectoryAddress-" stringByAppendingString:key]];
    //可以加
}

- (void)touchMoveData:(NSString *)str key:(NSString *)key;{
    CGRect frame = NSRectFromString(str);
    NSString *x = [NSString stringWithFormat:@"%.1f",frame.origin.x];
    NSString *y = [NSString stringWithFormat:@"%.1f",frame.origin.y];
    self.textView.stringValue = [key stringByAppendingFormat:@": 绝对位置\nX:%@\nY:%@",x,y];
    [[NSUserDefaults standardUserDefaults] setObject:str
                                              forKey:[@"frame-" stringByAppendingString:key]];
}
#pragma -mark get &set


#pragma -mark other
-(NSArray *)getFiles:(NSString *)basePath;{
    // 工程目录
//    NSString *BASE_PATH = path;
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:basePath];

    NSMutableArray *list = [NSMutableArray array];
    //列举目录内容，可以遍历子目录
    for (NSString *path in myDirectoryEnumerator.allObjects) {
        NSLog(@"files: \"%@\"\n", [basePath stringByAppendingString:path]);  // 所有路径
        if(![path isEqualToString:@".DS_Store"]){//移除mac特有文件夹配置文件
            [list addObject:[basePath stringByAppendingString:path]];
        }
    }
    return list;
}

#pragma -mark textField sth

- (void)textFieldHandle{
    self.bgPathTextField.enabled = NO;
    self.leftupTextField.enabled = NO;
    self.rightupTextField.enabled = NO;
    self.leftdownTextField.enabled = NO;
    self.rightdownTextField.enabled = NO;
    [self.bgPathTextField setFont:[NSFont systemFontOfSize:12.f]];
    [self.leftupTextField setFont:[NSFont systemFontOfSize:12.f]];
    [self.rightupTextField setFont:[NSFont systemFontOfSize:12.f]];
    [self.leftdownTextField setFont:[NSFont systemFontOfSize:12.f]];
    [self.rightdownTextField setFont:[NSFont systemFontOfSize:12.f]];
}

//
- (IBAction)emptyBgPathAction:(id)sender {
}
- (IBAction)emptyAPathAction:(id)sender {
}
- (IBAction)emptyBPathAction:(id)sender {
}
- (IBAction)emptyCPathAction:(id)sender {
}
- (IBAction)emptyDPathAction:(id)sender {
}


@end
