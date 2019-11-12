//
//  ExhibitionView.h
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/10.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@protocol urlDelegate <NSObject>
- (void)receiveUrlMessage:(NSString *)url key:(NSString *)key;
- (void)touchMoveData:(NSString *)str key:(NSString *)key;
@end


@interface ExhibitionView : NSImageView
@property (nonatomic,weak) id<urlDelegate> delegate;
@property (nonatomic,strong) NSString *key;
//两个瞄点
@property(nonatomic,assign) CGPoint leftDownPoint;
@property(nonatomic,assign) CGPoint rightUpPoint;

-(void)setLabelString:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
