//
//  CGTImage.h
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/16.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTImage : NSObject

@property (nonatomic,strong) NSImage *img;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

#pragma -mark init
- (CGTImage *)initImage:(NSImage *)img
                      x:(CGFloat)x
                      y:(CGFloat)y;

@end

NS_ASSUME_NONNULL_END
