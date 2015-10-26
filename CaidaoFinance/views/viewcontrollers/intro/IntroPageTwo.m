//
//  IntroPageTwo.m
//  
//
//  Created by MBP on 15/7/14.
//
//

#import "IntroPageTwo.h"

@implementation IntroPageTwo


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (iPhone4) {
        [self setX:30];
    }
    else if (iPhone5) {
        [self setX:30];
    }
    else if (iPhone6) {
        [self setX:60];
    }
    else
    {
        [self setX:40];
    }
}



- (void)setX:(CGFloat)x {
    self.img.frame = CGRectMake(x, self.img.frame.origin.y, self.img.frame.size.width, self.img.frame.size.height);
}
@end
