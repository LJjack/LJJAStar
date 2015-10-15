//
//  LJJNode.m
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/14.
//  Copyright © 2015年 LJ. All rights reserved.
//

#import "LJJNode.h"

@implementation LJJNode
- (BOOL)isEqual:(id)object {
    LJJNode *other = (LJJNode *)object;
    if (self==nil||other==nil) {
        return NO;
    }
    if ((self.x == other.x)&&(self.y == other.y)) {
        return YES;
    }
    return NO;
}
@end
