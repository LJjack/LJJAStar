//
//  LJJView.m
//  LJJAStar
//
//  Created by 刘俊杰 on 15/10/10.
//  Copyright © 2015年 LJ. All rights reserved.
//
#import "LJJView.h"
#import "LJJAStarPathfinding.h"



@interface LJJView ()
{
    CGMutablePathRef _mPath;
    NSArray *_mapArray,*_wayList;
    NSInteger _num,_mapWidth,_mapHeight,_mapCell,_mapColumn,_mapRow;
    
}
@end
@implementation LJJView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        __weak typeof(LJJView) *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"mapData.geojson" ofType:nil];
            NSData *mapData = [NSData dataWithContentsOfFile:path];
            
            LJJAStarPathfinding *aStar = [[LJJAStarPathfinding alloc] initWithMapData:mapData];
            _mapArray = [aStar getMapArray];
            _wayList = [aStar getWayList];
            _num = _wayList.count;
            _mapWidth = aStar.mapWidth;
            _mapHeight = aStar.mapHeight;
            _mapCell = aStar.mapCell;
            _mapColumn = aStar.mapColumn;
            _mapRow = aStar.mapRow;
            [weakSelf setupMap];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf goAnimation];
            });
        });
        
        
    }
    return self;
}

- (void)setupMap {
    _mPath = CGPathCreateMutable();
    
    //竖线
    for (NSInteger i = 0; i <= _mapColumn; i ++) {
        CGPathMoveToPoint(_mPath, NULL, i*_mapCell, 0);
        CGPathAddLineToPoint(_mPath, NULL, i*_mapCell, _mapHeight);
    }
    // 横线
    for (NSInteger i = 0; i <= _mapRow; i ++) {
        CGPathMoveToPoint(_mPath, NULL, 0, i*_mapCell);
        CGPathAddLineToPoint(_mPath, NULL, _mapWidth, i*_mapCell);
    }
}

- (void)drawRect:(CGRect)rect {
   

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextAddPath(context, _mPath);
    CGContextStrokePath(context);
    [self drawMapContext:context];
    [[UIColor cyanColor] set];
    CGContextFillRect(context, CGRectMake([_wayList[_num][@"x"] integerValue]*_mapCell+1, [_wayList[_num][@"y"] integerValue]*_mapCell+1, _mapCell-2, _mapCell-2));

}
- (void)drawMapContext:(CGContextRef)context {
    for (NSInteger y = 0; y<_mapRow; y++) {
        for (NSInteger x = 0; x<_mapColumn; x++) {
            switch ([_mapArray[y][x] integerValue]) {
                case LJJTypeSpace:
                    break;
                case LJJTypeStart:
                    [[UIColor greenColor] set];
                    CGContextFillRect(context, CGRectMake(x*_mapCell+1, y*_mapCell+1, _mapCell-2, _mapCell-2));
                    break;
                case LJJTypeEnd:
                    [[UIColor redColor] set];
                    CGContextFillRect(context, CGRectMake(x*_mapCell+1, y*_mapCell+1, _mapCell-2, _mapCell-2));
                    break;
                case LJJTypeObstacle:
                    [[UIColor blueColor] set];
                    CGContextFillRect(context, CGRectMake(x*_mapCell+1, y*_mapCell+1, _mapCell-2, _mapCell-2));
                    break;
                case LJJTypeWay:
                    [[UIColor yellowColor] set];
                    CGContextFillRect(context, CGRectMake(x*_mapCell+1, y*_mapCell+1, _mapCell-2, _mapCell-2));
                    break;
                default:
                    break;
            }
        }
    }
    
}
- (void)goAnimation {
    
    if (_num>0) {
        [self setNeedsDisplay];
        [self performSelector:@selector(goAnimation) withObject:nil afterDelay:0.5];
    }else{
        NSLog(@"finish");
    }
    _num--;
}
- (void)dealloc {
    CGPathRelease(_mPath);
}

@end
