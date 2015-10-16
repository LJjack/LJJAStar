//
//  LJJAStarPathfinding.h
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/15.
//  Copyright © 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ENUM(NSInteger){
    LJJTypeSpace = 0,
    LJJTypeStart = 1,
    LJJTypeEnd = 2,
    LJJTypeObstacle = 3,
    LJJTypeWay = 8
};
@interface LJJAStarPathfinding : NSObject
@property (assign,nonatomic,readonly) NSInteger mapWidth;
@property (assign,nonatomic,readonly) NSInteger mapHeight;
@property (assign,nonatomic,readonly) NSInteger mapCell;
@property (assign,nonatomic,readonly) NSInteger mapColumn;
@property (assign,nonatomic,readonly) NSInteger mapRow;
/**
 *  地图data
 */
- (instancetype)initWithMapData:(NSData *)mapData;
- (NSArray *)getMapArray;
- (NSArray *)getWayList;
@end
