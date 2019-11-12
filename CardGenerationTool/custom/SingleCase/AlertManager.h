//
//  CGTAlert.h
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/11.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSAlert

+ (instancetype)sharedInstance;
- (void)showDefaultAlert:(NSView *)targerView;
- (void)showWarnAlert:(NSView *)targerView
                title:(NSString *)title
                 text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
