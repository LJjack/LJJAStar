//
//  LJJAStarPathfinding.m
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/15.
//  Copyright © 2015年 LJ. All rights reserved.
//
#import "LJJAStarPathfinding.h"
#import "LJJNode.h"

@interface LJJAStarPathfinding ()
{
    NSMutableArray *_openList,*_closedList,*_wayList,*_mapArray;
    NSDictionary *startD,*endD;
}
@end

@implementation LJJAStarPathfinding
- (instancetype)initWithMapData:(NSData *)mapData {
    if (self = [super init]) {
        [self configMapData:mapData];
        [self calculateAStar];
    }
    return self;
}
- (void)configMapData:(NSData *)mapData {
    NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData:mapData options:NSJSONReadingAllowFragments error:nil];
    _mapWidth = [dicts[@"mapWidth"] integerValue];
    _mapHeight = [dicts[@"mapHeight"] integerValue];
    _mapCell = [dicts[@"mapCell"] integerValue];
    _mapColumn = _mapWidth/_mapCell;
    _mapRow = _mapHeight/_mapCell;
    _mapArray = [NSMutableArray array];
    //space
    for (NSInteger i = 0; i<_mapRow; i++) {
        NSMutableArray *xArray = [NSMutableArray array];
        for (NSInteger j = 0; j<_mapColumn; j++) {
            [xArray addObject:@(LJJTypeSpace)];
        }
        [_mapArray addObject:xArray];
    }
    
    //start
    NSDictionary *startDict = dicts[@"start"];
    NSMutableArray *xSArray = _mapArray[[startDict[@"y"] integerValue]];
    [xSArray replaceObjectAtIndex:[startDict[@"x"] integerValue] withObject:@(LJJTypeStart)];
    startD = startDict;
    //end
    NSDictionary *endDict = dicts[@"end"];
    NSMutableArray *xEArray = _mapArray[[endDict[@"y"] integerValue]];
    [xEArray replaceObjectAtIndex:[endDict[@"x"] integerValue] withObject:@(LJJTypeEnd)];
    endD = endDict;
    //obstacle
    NSArray *obstacleArray = dicts[@"obstacle"];
    for (NSDictionary *dict in obstacleArray) {
        NSMutableArray *xOArray = _mapArray[[dict[@"y"] integerValue]];
        [xOArray replaceObjectAtIndex:[dict[@"x"] integerValue] withObject:@(LJJTypeObstacle)];
    }
}
- (LJJNode *)createNode {
    LJJNode *node = [[LJJNode alloc] init];
    node.x = 0;
    node.y = 0;
    node.f = 0;
    node.previousNode = nil;
    node.nextNode = nil;
    return node;
}
- (void)calculateAStar {
    _openList = [NSMutableArray array];
    _closedList = [NSMutableArray array];
    _wayList = [NSMutableArray array];
    LJJNode *startNode = [self createNode];
    LJJNode *endNode = [self createNode];
    NSInteger startX = [startD[@"x"] integerValue];
    NSInteger startY = [startD[@"y"] integerValue];
    NSInteger endX = [endD[@"x"] integerValue];
    NSInteger endY = [endD[@"y"] integerValue];
    startNode.x = startX;
    startNode.y = startY;
    endNode.x = endX;
    endNode.y = endY;
    startNode.f = [self getFnGnHnfristNode:startNode secendNode:endNode];
    [_openList addObject:startNode];
    do {
        // 寻找f值最小的节点, 设置为当前节点
        LJJNode *lowestWayNode = [self getOpenListWithLowestWay];
        [_closedList addObject:lowestWayNode];
        [_openList removeObject:lowestWayNode];
        if ([_closedList containsObject:endNode]) {
            break;
        }
        NSArray *directionArray = [self getDirectionArrayWithNode:lowestWayNode];
        for ( LJJNode *currentNode in directionArray) {
            // f(n) = g(n) +h(n)
            NSInteger gN = lowestWayNode.f;
            NSInteger hN = [self getFnGnHnfristNode:currentNode secendNode:endNode];
            NSInteger fN = gN + hN;
            currentNode.f = fN;
            currentNode.previousNode = lowestWayNode;
            
            if (![_openList containsObject:currentNode]) {
                [_openList addObject:currentNode];
            }else {
                //替换openList的最小路径
                if (fN<lowestWayNode.f) {
                    lowestWayNode.previousNode = currentNode;
                }
            }
        }
    } while (_openList.count>0);
    LJJNode *lastClosedListNode = [_closedList lastObject];
    LJJNode *pNode = lastClosedListNode.previousNode;
    if (pNode == nil) {
        return;
    }
    while (pNode.previousNode != NULL) {
        NSMutableArray *xWArray = _mapArray[pNode.y];
        [xWArray replaceObjectAtIndex:pNode.x withObject:@(LJJTypeWay)];
        [_wayList addObject:@{@"x":@(pNode.x),@"y":@(pNode.y)}];
        pNode = pNode.previousNode;
    }
    [_wayList insertObject:@{@"x":@(lastClosedListNode.x),@"y":@(lastClosedListNode.y)} atIndex:0];
    
}
//估计函数的选区
- (NSInteger)getFnGnHnfristNode:(LJJNode *)fristNode secendNode:(LJJNode *)secendNode {
    return pow((fristNode.x-secendNode.x), 2)+pow((fristNode.y-secendNode.y), 2);
}
//获取openList中最小f值的节点
- (LJJNode *)getOpenListWithLowestWay {
    LJJNode *minNode = _openList[0];
    for (LJJNode *node in _openList) {
        if (minNode.f>node.f) {
            minNode = node;
        }
    }
    return minNode;
}
//获取满足条件的节点
- (NSArray *)getDirectionArrayWithNode:(LJJNode *)node {
    NSMutableArray * directionArray = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = -1; i < 2; i ++) {
        for (NSInteger j = -1; j < 2; j ++) {
            if(i*j!= 0) {//如果去掉这个条件，就变成对八个方向判断
                continue;
            }
            if (i==0&&j==0) {
                continue;
            }
            NSInteger x = node.x + i;
            NSInteger y = node.y + j;
            if (x < 0||y < 0||x > (_mapColumn-1)||y > (_mapRow-1)) {
                continue;
            }
            if ([_mapArray[y][x] integerValue] == LJJTypeObstacle) {
                continue;
            }
            LJJNode *currentNode = [self createNode];
            currentNode.x = x;
            currentNode.y = y;
            if ([_closedList containsObject:currentNode]) {
                continue;
            }
            
            [directionArray addObject:currentNode];
            
        }
    }
    return directionArray;
    
}
- (NSArray *)getMapArray {
    return _mapArray;
}
- (NSArray *)getWayList {
    return _wayList;
}
@end
