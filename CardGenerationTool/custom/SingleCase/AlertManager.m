//
//  CGTAlert.m
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/11.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager


+ (instancetype)sharedInstance;{
    static dispatch_once_t onceToken;
    static AlertManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AlertManager alloc] init];
    });
    return sharedInstance;
}

-(void)showWarnAlert:(NSView *)targerView
               title:(NSString *)title
                text:(NSString *)text;{
    
    NSString *useTitle = title;
    if(!useTitle || [useTitle isEqualToString:@""]){
        useTitle = @"警告";
    }
    
    [self showCustomAlertIn:targerView
                       type:NSAlertStyleInformational
                      title:useTitle
                rightButton:@""
                 leftButton:@""
                       text:text];
}


-(void)showDefaultAlert:(NSView *)targerView{
    [self showCustomAlertIn:targerView
                       type:NSAlertStyleInformational
                      title:@"警告"
                rightButton:@""
                 leftButton:@""
                       text:@"警告信息"];
}

- (void)showCustomAlertIn:(NSView *)targerView
                     type:(NSAlertStyle )type
                    title:(NSString *)title
              rightButton:(NSString *)rightButton
               leftButton:(NSString *)leftButton
                     text:(NSString *)text;{
    
    NSAlert * alert = [[NSAlert alloc]init];
    alert.alertStyle = type;
    alert.messageText = title;
    if(![rightButton isEqualToString:@""]){
        [alert addButtonWithTitle:rightButton];
    }
    if(![leftButton isEqualToString:@""]){
        [alert addButtonWithTitle:leftButton];
    }
    [alert setInformativeText:text];
    
    [alert beginSheetModalForWindow:[targerView window] completionHandler:^(NSModalResponse returnCode) {
        switch (returnCode) {
            case NSModalResponseOK:
                NSLog(@"(returnCode == NSOKButton)");
                break;
            case NSModalResponseCancel:
                NSLog(@"(returnCode == NSCancelButton)");
                break;
            case NSAlertFirstButtonReturn:
                NSLog(@"(returnCode == NSAlertFirstButtonReturn)");
                break;
            case NSAlertSecondButtonReturn:
                NSLog(@"(returnCode == NSAlertSecondButtonReturn)");
                break;
            case NSAlertThirdButtonReturn:
                NSLog(@"(returnCode == NSAlertThirdButtonReturn)");
                break;
            default:
                NSLog(@"All Other return code %ld",(long)returnCode);
                break;
        }
    }];
}



//    NSAlert * alert = [[NSAlert alloc]init];
//    alert.messageText = @"警告";
//    alert.alertStyle = NSAlertStyleInformational;
//    [alert addButtonWithTitle:@"continue"];
//    [alert addButtonWithTitle:@"cancle"];
//    [alert setInformativeText:@"NSWarningAlertStyle \r Do you want to continue with delete of selected records"];
//    [alert beginSheetModalForWindow:[targerView window] completionHandler:^(NSModalResponse returnCode) {
//        if (returnCode == NSModalResponseOK){
//            NSLog(@"(returnCode == NSOKButton)");
//        }else if (returnCode == NSModalResponseCancel){
//            NSLog(@"(returnCode == NSCancelButton)");
//        }else if(returnCode == NSAlertFirstButtonReturn){
//            NSLog(@"if (returnCode == NSAlertFirstButtonReturn)");
//        }else if (returnCode == NSAlertSecondButtonReturn){
//            NSLog(@"else if (returnCode == NSAlertSecondButtonReturn)");
//        }else if (returnCode == NSAlertThirdButtonReturn){
//            NSLog(@"else if (returnCode == NSAlertThirdButtonReturn)");
//        }else{
//            NSLog(@"All Other return code %ld",(long)returnCode);
//        }
//    }];



@end
