//
//  ExhibitionView.m
//  CardGenerationTool
//
//  Created by 张玺臣 on 2019/10/10.
//  Copyright © 2019 张玺臣. All rights reserved.
//


/*
 *  用于展览image的View
    需求：
        1.需要实现拖拽相应
        2.记住上次拖拽的图片
        3.展示出当前路径的图片
 */
#import "ExhibitionView.h"

@interface ExhibitionView()<NSDraggingSource,NSPasteboardItemDataProvider>
@property(nonatomic,assign) BOOL isDragIn;//图片是否拖拽
@property(nonatomic,strong) NSTrackingArea *trackingArea;
@property(nonatomic,strong) NSTextField *label;

@end

@implementation ExhibitionView




- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self addSubview:self.label];
    
    self.wantsLayer = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [NSColor grayColor].CGColor;
    
    if(_isDragIn) {
        NSLog(@"拖拽了外文件");
    }
    if(self.trackingAreas.count == 0){
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:dirtyRect
                                                         options:
                             NSTrackingMouseEnteredAndExited |
                             NSTrackingMouseMoved |
                             NSTrackingCursorUpdate |
                             NSTrackingActiveWhenFirstResponder |
                             NSTrackingActiveInKeyWindow |
                             NSTrackingActiveInActiveApp |
                             NSTrackingActiveAlways |
                             NSTrackingAssumeInside |
                             NSTrackingInVisibleRect |
                             NSTrackingEnabledDuringMouseDrag
                                                           owner:self
                                                        userInfo:nil];
        [self addTrackingArea:self.trackingArea];
        [self becomeFirstResponder];
        NSLog(@"trackingArea count :\n%ld\n",self.trackingAreas.count);
    }
}

#pragma -mark 拖拽图片进入视图区域

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
            if(self.delegate && [self.delegate respondsToSelector:@selector(receiveUrlMessage: key:)]){
                [self.delegate receiveUrlMessage:[NSString stringWithFormat:@"%@",filePaths.firstObject] key:self.key];
            }
        }else{
            [[AlertManager sharedInstance] showWarnAlert:self title:@"警告" text:@"请不要拖拽多个文件"];
        }
    }
    return YES;
}

#pragma -mark 鼠标区域

//鼠标进入追踪区域
- (void)mouseEntered:(NSEvent *)event;{
//    NSLog(@"mouseEntered ==========");
}
//mouseEntered 之后调用
- (void)cursorUpdate:(NSEvent *)event{
//    NSLog(@"cursorUpdate ==========");
}
//鼠标退出追踪区域
- (void)mouseExited:(NSEvent *)event{
//    NSLog(@"mouseExited ---------- ");
}
//鼠标左键按下
- (void)mouseDown:(NSEvent *)event{
    NSLog(@"mouseDown ---------- ");
//    NSPoint eventLocation = [event locationInWindow];
//    NSPoint center = [self convertPoint:eventLocation fromView:nil];
//
//    //与上面等价
//    NSPoint clickLocation = [self convertPoint:[event locationInWindow]
//                                      fromView:nil];
//
//    NSStringFromPoint(center)
//    NSLog(@"center：%@ , clickLocation：%@",NSStringFromPoint(center),NSStringFromPoint(clickLocation));
//
//    //判断是否按下了Command键
//    if ([event modifierFlags] & NSCommandKeyMask) {
//        [self setFrameRotation:[self frameRotation]+90.0];
//        [self setNeedsDisplay:YES];
//
//        NSLog(@"按下了Command键 ------ ");
//    }
}


//鼠标左键起来
- (void)mouseUp:(NSEvent *)event{
//    NSLog(@"mouseUp ========== ");
}

//鼠标右键按下
- (void)rightMouseDown:(NSEvent *)event{
//    NSLog(@"rightMouseDown ========== ");
}

//鼠标右键起来
- (void)rightMouseUp:(NSEvent *)event{
//    NSLog(@"rightMouseUp ========== ");
}

//鼠标移动 
- (void)mouseMoved:(NSEvent *)event{
//    NSLog(@"mouseMoved:%@",NSStringFromRect(self.frame));
//    NSLog(@"mouseMoved ========== ");
//    isAllowMove
//    if(self.leftDownPoint)
//    if(){
//        _isAllowMove = YES;
//    }
    
//    _isAllowMove =  [self isPoint:self.leftDownPoint inFrame:self.frame] &&
//                    [self isPoint:self.rightUpPoint inFrame:self.frame];
//    if(![self isPoint:event.locationInWindow inFrame:self.superview.frame]){
//        _isAllowMove =
//    }
//    NSLog(@"mouseMoved:%@",_isAllowMove?@"YES":@"NO");
}

//鼠标按住左键进行拖拽
- (void)mouseDragged:(NSEvent *)event{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(event.locationInWindow.x, event.locationInWindow.y);
    self.frame = frame;
    
    [self setNeedsDisplay:YES];
    if(self.delegate  && [self.delegate respondsToSelector:@selector(touchMoveData:key:)]){
        [self.delegate touchMoveData:NSStringFromRect(self.frame) key:self.key];
    }
}



#pragma -mark other

-(void)setLabelString:(NSString *)text;{
    self.label.stringValue = text;
    CGFloat width = [text boundingRectWithSize:self.label.frame.size
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:8]}].size.width;
    CGRect frame = self.label.frame;
    frame.size.width = width + 8;
    self.label.frame = frame;
}


#pragma -mark Dragging

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context;{
    NSLog(@"NSDragOperationMove");
    return NSDragOperationMove;
}

- (void)pasteboard:(nullable NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSPasteboardType)type;{
    NSLog(@"provideDataForType");
    return ;
}


//math
- (BOOL )isPoint:(NSPoint )point inFrame:(NSRect )frame;{
    CGFloat maxX = frame.origin.x + frame.size.width;
    CGFloat minX = frame.origin.x;
    CGFloat maxY = frame.origin.y + frame.size.height;
    CGFloat minY = frame.origin.y;
    
    if( point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY){
        return YES;
    }else{
        return NO;
    }
}


#pragma -mark get &set

- (NSTextField *)label;{
    if(!_label){
        _label = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        _label.stringValue = @"";
        _label.editable = NO;
        _label.font = [NSFont userFontOfSize:8.f];
    }
    return _label;
}

- (CGPoint )leftDownPoint;{
    return self.frame.origin;
}

- (CGPoint )rightUpPoint;{
    CGPoint p = CGPointMake(self.frame.origin.x + self.frame.size.width,
                            self.frame.origin.y + self.frame.size.height);
    return p;
}

@end
