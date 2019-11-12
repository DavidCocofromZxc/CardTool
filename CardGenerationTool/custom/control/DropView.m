//
//  DropView.m
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/18.
//  Copyright © 2019 张玺臣. All rights reserved.
//

#import "DropView.h"

@interface DropView()<NSDraggingSource,NSPasteboardItemDataProvider>
@property(nonatomic,assign) BOOL isDragIn;
@end

@implementation DropView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if(_isDragIn) {
        NSLog(@"拖拽了");
    }
    // Drawing code here.
}



#pragma -mark 拖拽图片进入
- (NSDragOperation)draggingEntered:(id)sender;{
    [super draggingEntered:sender];
    NSLog(@"\ndraggingEntered:\n");
    _isDragIn = YES;
    [self setNeedsDisplay:YES];
    return NSDragOperationCopy;
}
- (void)draggingExited:(id)sender;{
    [super draggingExited:sender];
    NSLog(@"\ndraggingEntered:\n");
    _isDragIn = NO;
    [self setNeedsDisplay:YES];
}
- (BOOL)prepareForDragOperation:(id)sender;{
    [super prepareForDragOperation:sender];
    NSLog(@"\nprepareForDragOperation:\n");
    _isDragIn = NO;
    [self setNeedsDisplay:YES];
    return YES;
}
- (BOOL)performDragOperation:(id)sender;{
    [super performDragOperation:sender];
    NSLog(@"\nperformDragOperation:\n");
    if([sender draggingSource] != self ){
        NSArray* filePaths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        NSLog(@"文件地址%@",filePaths);
        if(filePaths.count == 1){
            NSLog(@"allow sender");
//            if(self.delegate && [self.delegate respondsToSelector:@selector(receiveUrlMessage: key:)]){
//                [self.delegate receiveUrlMessage:[NSString stringWithFormat:@"%@",filePaths.firstObject] key:self.key];
//            }
        }else{
            [[AlertManager sharedInstance] showWarnAlert:self title:@"警告" text:@"请不要拖拽多个文件"];
        }
    }
    return YES;
}


#pragma -mark Dragging

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context;{
    return NSDragOperationMove;
}

- (void)pasteboard:(nullable NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSPasteboardType)type;{
    return ;
}




@end
