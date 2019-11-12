//
//  CGTImage.m
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/16.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "CGTImage.h"

@implementation CGTImage

- (CGTImage *)initImage:(NSImage *)img
                      x:(CGFloat)x
                      y:(CGFloat)y;{

    if(!self){
        self = [super init];
    }
    self.img = img;
    self.x = x;
    self.y = y;
    return self;
}
@end
