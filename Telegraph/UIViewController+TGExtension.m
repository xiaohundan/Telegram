//
//  UIViewController+TGExtension.m
//  Telegraph
//
//  Created by 问聊 on 16/11/28.
//
//

#import "UIViewController+TGExtension.h"
#import <objc/runtime.h>
@implementation UIViewController (TGExtension)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(DDViewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector,  method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else
        {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

-(void)DDViewWillAppear:(BOOL) animated
{
    [self DDViewWillAppear:animated];
    NSLog(@"-----------%@", self);
}


@end
