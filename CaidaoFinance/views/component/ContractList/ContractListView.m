//
//  ContractListView.m
//  
//
//  Created by MBP on 15/7/6.
//
//

#import "ContractListView.h"

@interface ContractListView ()
{
    UILabel * lastLabel;
}

@end

@implementation ContractListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSInteger tag = gesture.view.tag;
    if ([_delegate respondsToSelector:@selector(didSelectedContract:)]) {
        [_delegate didSelectedContract:tag];
    }
    
}

- (void)buttonAction:(UIButton*)sender {
    NSInteger tag = sender.tag;
    if ([_delegate respondsToSelector:@selector(didSelectedContract:)]) {
        [_delegate didSelectedContract:tag];
    }
}

- (void)showContractList:(NSArray *)lists {
    
    for (int i = 0; i<[lists count]; i++) {
        NSDictionary * dic = lists[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBCOLOR(47, 150, 211);
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14];
        label.tag = i;
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[dic objectForKey:@"name"]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        label.attributedText = content;
        [self addSubview:label];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastLabel) {
                make.top.equalTo(lastLabel.mas_bottom).offset(10);
                make.left.equalTo(@10);
            }
            else
            {
                make.top.equalTo(@0);
                make.left.equalTo(@10);
            }
            make.height.equalTo(@20);
            if (i == [lists count] - 1) {
                make.bottom.equalTo(@-5);
            }
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label);
            make.right.equalTo(label);
            make.top.equalTo(label);
            make.bottom.equalTo(label);
        }];
        lastLabel = label;
    }
    
}

@end
