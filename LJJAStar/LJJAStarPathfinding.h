//
//  LJJAStarPathfinding.h
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/15.
//  Copyright © 2015年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const NSInteger kMapWidth ;
extern const NSInteger kMapHeight ;
extern const NSInteger kCell ;
extern const NSInteger kMapColumn ;
extern const NSInteger kMapRow;
NS_ENUM(NSInteger){
    LJJTypeSpace = 0,
    LJJTypeStart = 1,
    LJJTypeEnd = 2,
    LJJTypeObstacle = 3,
    LJJTypeWay = 8
};
@interface LJJAStarPathfinding : NSObject
- (NSArray *)getMapArray;
- (NSArray *)getWayList;
@end
