//
//  FileManager.h
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/15.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^QuerySuccessBlock)(NSFileManager *manager);
typedef void (^QueryFailBlock)(NSFileManager *manager);
typedef void (^doSomthingBlock)(NSFileManager *manager);


@interface FileManager : NSObject

+ (instancetype)sharedInstance;
// 自定义-根据文件路径搜索文件
- (BOOL)queryFile:(NSString *)url
          success:(QuerySuccessBlock)successBlock
             fail:(QueryFailBlock)failBlock;
// 标准-根据文件路径搜索文件
- (void)standardQueryFile:(NSString *)path
              doSomething:(doSomthingBlock)someBlock;
@end

NS_ASSUME_NONNULL_END
