//
//  FileManager.m
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/15.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (instancetype)sharedInstance;{
    static dispatch_once_t onceToken;
    static FileManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FileManager alloc] init];
    });
    return sharedInstance;
}
/**
    根据文件路径搜索文件(同步)
 */
- (BOOL)queryFile:(NSString *)url
          success:(QuerySuccessBlock)successBlock
             fail:(QueryFailBlock)failBlock;{    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result = [manager fileExistsAtPath:url];    //判断文件是否存在
    if (result) {
        if(successBlock){
            successBlock(manager);
        }
        return NO;
    }
    else{
        if(failBlock){
            failBlock(manager);
        }
        return YES;
    }
}

- (void)standardQueryFile:(NSString *)path
              doSomething:(doSomthingBlock)someBlock{
    
    [self queryFile:path success:^(NSFileManager * _Nonnull manager) {
        //搜索成功->加载显示
        NSLog(@"\n\"path:%@\",\nquery success!\n",path);
        if(someBlock){
            someBlock(manager);
        }
    } fail:^(NSFileManager * _Nonnull manager) {
        NSLog(@"\n\"path:%@\",\nquery fail!\n",path);
        BOOL isCreate = [manager createFileAtPath:path contents:[path dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        if (isCreate) {
            NSLog(@"创建成功");
            NSError * error;
            if (error) {
                NSLog(@"save error:%@",error.description);
            }
        }
        else{
            NSLog(@"🌺 创建失败");
        }
    }];
}

@end
