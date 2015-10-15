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
    NSInteger _num;
    
}
@end
@implementation LJJView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        LJJAStarPathfinding *aStar = [[LJJAStarPathfinding alloc] init];
        _mapArray = [aStar getMapArray];
        _wayList = [aStar getWayList];
        NSLog(@"maparray = %@",_mapArray);
        NSLog(@"_wayList = %@",_wayList);
        _num = _wayList.count;
        [self setupMap];
        [self goAnimation];
    }
    return self;
}

- (void)setupMap {
    _mPath = CGPathCreateMutable();
    
    //竖线
    for (NSInteger i = 0; i <= kMapColumn; i ++) {
        CGPathMoveToPoint(_mPath, NULL, i*kCell, 0);
        CGPathAddLineToPoint(_mPath, NULL, i*kCell, kMapHeight);
    }
    // 横线
    for (NSInteger i = 0; i <= kMapRow; i ++) {
        CGPathMoveToPoint(_mPath, NULL, 0, i*kCell);
        CGPathAddLineToPoint(_mPath, NULL, kMapWidth, i*kCell);
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
    CGContextFillRect(context, CGRectMake([_wayList[_num][@"x"] integerValue]*kCell+1, [_wayList[_num][@"y"] integerValue]*kCell+1, kCell-2, kCell-2));

}
- (void)drawMapContext:(CGContextRef)context {
    for (NSInteger y = 0; y<kMapRow; y++) {
        for (NSInteger x = 0; x<kMapColumn; x++) {
            switch ([_mapArray[y][x] integerValue]) {
                case LJJTypeSpace:
                    break;
                case LJJTypeStart:
                    [[UIColor greenColor] set];
                    CGContextFillRect(context, CGRectMake(x*kCell+1, y*kCell+1, kCell-2, kCell-2));
                    break;
                case LJJTypeEnd:
                    [[UIColor redColor] set];
                    CGContextFillRect(context, CGRectMake(x*kCell+1, y*kCell+1, kCell-2, kCell-2));
                    break;
                case LJJTypeObstacle:
                    [[UIColor blueColor] set];
                    CGContextFillRect(context, CGRectMake(x*kCell+1, y*kCell+1, kCell-2, kCell-2));
                    break;
                case LJJTypeWay:
                    [[UIColor yellowColor] set];
                    CGContextFillRect(context, CGRectMake(x*kCell+1, y*kCell+1, kCell-2, kCell-2));
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
