//
//  LJJNode.h
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/14.
//  Copyright © 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJJNode : NSObject
@property (assign,nonatomic) NSInteger x;
@property (assign,nonatomic) NSInteger y;
@property (assign,nonatomic) NSInteger f;
@property (strong,nonatomic) LJJNode *nextNode;//链表下一个节点
@property (strong,nonatomic) LJJNode *previousNode;//是最优路径的上个节点
@end
