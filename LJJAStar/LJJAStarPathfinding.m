//
//  LJJAStarPathfinding.m
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/15.
//  Copyright © 2015年 LJ. All rights reserved.
//
#import "LJJAStarPathfinding.h"
#import "LJJNode.h"
const NSInteger kMapWidth = 300;
const NSInteger kMapHeight = 300;
const NSInteger kCell = 10;
const NSInteger kMapColumn = kMapWidth/kCell;
const NSInteger kMapRow = kMapHeight/kCell;
@interface LJJAStarPathfinding ()
{
    NSMutableArray *_openList,*_closedList,*_wayList,*_mapArray;
    //    NSInteger mapArray[kMapRow][kMapColumn];
    
    NSDictionary *startD,*endD;
}
@end

@implementation LJJAStarPathfinding
- (instancetype)init {
    if (self = [super init]) {
        [self configMapData];
        [self calculateAStar];
    }
    return self;
}
- (void)configMapData {
    _mapArray = [NSMutableArray array];
    //space
    for (NSInteger i = 0; i<kMapRow; i++) {
        NSMutableArray *xArray = [NSMutableArray array];
        for (NSInteger j = 0; j<kMapColumn; j++) {
            //            mapArray[i][j] = LJJTypeSpace;
            [xArray addObject:@(LJJTypeSpace)];
        }
        [_mapArray addObject:xArray];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mapData.geojson" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //start
    NSDictionary *startDict = dicts[@"start"];
    //    mapArray[[startDict[@"y"] integerValue]][[startDict[@"x"] integerValue]] = LJJTypeStart;
    NSMutableArray *xSArray = _mapArray[[startDict[@"y"] integerValue]];
    [xSArray replaceObjectAtIndex:[startDict[@"x"] integerValue] withObject:@(LJJTypeStart)];
    startD = startDict;
    //end
    NSDictionary *endDict = dicts[@"end"];
    //    mapArray[[endDict[@"y"] integerValue]][[endDict[@"x"] integerValue]] = LJJTypeEnd;
    NSMutableArray *xEArray = _mapArray[[endDict[@"y"] integerValue]];
    [xEArray replaceObjectAtIndex:[endDict[@"x"] integerValue] withObject:@(LJJTypeEnd)];
    endD = endDict;
    //obstacle
    NSArray *obstacleArray = dicts[@"obstacle"];
    for (NSDictionary *dict in obstacleArray) {
        //        mapArray[[dict[@"y"] integerValue]][[dict[@"x"] integerValue]] = LJJTypeObstacle;
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
- (NSInteger)getFnGnHnfristNode:(LJJNode *)fristNode secendNode:(LJJNode *)secendNode {
    return pow((fristNode.x-secendNode.x), 2)+pow((fristNode.y-secendNode.y), 2);
}
- (LJJNode *)getOpenListWithLowestWay {
    LJJNode *minNode = _openList[0];
    for (LJJNode *node in _openList) {
        if (minNode.f>node.f) {
            minNode = node;
        }
    }
    return minNode;
}
- (LJJNode *)getOpenListEqualNode:(LJJNode *)node {
    return _openList[[_openList indexOfObject:node]];
}
- (NSArray *)getDirectionArrayWithNode:(LJJNode *)node {
    NSMutableArray * directionArray = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = -1; i < 2; i ++) {
        for (NSInteger j = -1; j < 2; j ++) {
            if ((i*j!= 0)||(i==0&&j==0)) {
                continue;
            }
            NSInteger x = node.x + i;
            NSInteger y = node.y + j;
            if (x < 0||y < 0||x > (kMapColumn-1)||y > (kMapRow-1)) {
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
