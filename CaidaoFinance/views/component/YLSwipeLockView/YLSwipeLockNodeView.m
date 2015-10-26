//
//  YLSwipeLockNodeView.m
//  YLSwipeLockViewDemo
//
//  Created by 肖 玉龙 on 15/2/12.
//  Copyright (c) 2015年 Yulong Xiao. All rights reserved.
//

#import "YLSwipeLockNodeView.h"
#import "YLSwipeLockView.h"
@interface YLSwipeLockNodeView()
@property (nonatomic, strong)CAShapeLayer *outlineLayer;
@property (nonatomic, strong)CAShapeLayer *innerCircleLayer;
@property (nonatomic, strong)UIImageView *innerImg;
@end


@implementation YLSwipeLockNodeView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.outlineLayer];
//        [self.layer addSublayer:self.innerCircleLayer];
        self.nodeViewStatus = YLSwipeLockNodeViewStatusNormal;
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)rec
{
    NSLog(@"what the fuck");
    CGPoint point = [rec locationInView:self];
    NSLog(@"location in view:%f, %f", point.x, point.y);
    self.nodeViewStatus = YLSwipeLockNodeViewStatusSelected;
}

-(void)setNodeViewStatus:(YLSwipeLockNodeViewStatus)nodeViewStatus
{
    _nodeViewStatus = nodeViewStatus;
    switch (_nodeViewStatus) {
        case YLSwipeLockNodeViewStatusNormal:
            [self setStatusToNormal];
            break;
        case YLSwipeLockNodeViewStatusSelected:
            [self setStatusToSelected];
            break;
        case YLSwipeLockNodeViewStatusWarning:
            [self setStatusToWarning];
            break;
        default:
            break;
    }
}

-(void)setStatusToNormal
{
    self.outlineLayer.strokeColor = LIGHTBLUE.CGColor;
    self.outlineLayer.fillColor = LIGHTBLUE.CGColor;

    self.innerImg.image = nil;
//    self.innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
}

-(void)setStatusToSelected
{
//    self.outlineLayer.strokeColor = LIGHTBLUE.CGColor;
    self.innerImg.image = UIIMAGE(@"touch_pass_icon");
//    self.innerCircleLayer.fillColor = LIGHTBLUE.CGColor;
}

-(void)setStatusToWarning
{
    self.outlineLayer.strokeColor = [UIColor redColor].CGColor;
    self.outlineLayer.fillColor = [UIColor redColor].CGColor;
    self.innerImg.image = nil;
//    self.innerCircleLayer.fillColor = [UIColor redColor].CGColor;
    
}


-(void)layoutSubviews
{
    self.outlineLayer.frame = self.bounds;
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.outlineLayer.path = outlinePath.CGPath;
    
    CGRect frame = self.bounds;
    CGFloat width = frame.size.width / 3;
    self.innerCircleLayer.frame = CGRectMake(width, width, width, width);
    ///临时
   
//    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:self.innerCircleLayer.bounds];
//    self.innerCircleLayer.path = innerPath.CGPath;
    
    self.innerImg = [[UIImageView alloc] initWithFrame:CGRectMake(width, width, width, width)];
    self.innerImg.layer.masksToBounds = YES;
//    self.innerImg.image = UIIMAGE(@"qscan");
    self.innerImg.layer.cornerRadius = 13;
    [self addSubview:self.innerImg];
    [self.innerImg mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@0);
         make.right.equalTo(@0);
         make.top.equalTo(@0);
         make.bottom.equalTo(@0);

     }];
}

-(CAShapeLayer *)outlineLayer
{
    if (_outlineLayer == nil) {
        _outlineLayer = [[CAShapeLayer alloc] init];
        _outlineLayer.strokeColor = LIGHTBLUE.CGColor;
        _outlineLayer.lineWidth = 32.0f;
        _outlineLayer.fillColor  = LIGHTBLUE.CGColor;
    }
    return _outlineLayer;
}

-(CAShapeLayer *)innerCircleLayer
{
    if (_innerCircleLayer == nil) {
        _innerCircleLayer = [[CAShapeLayer alloc] init];
        _innerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
        _innerCircleLayer.lineWidth = 0.0f;
        _innerCircleLayer.fillColor  = LIGHTBLUE.CGColor;
    }
    return _innerCircleLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
