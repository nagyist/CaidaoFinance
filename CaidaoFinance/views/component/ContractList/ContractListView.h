//
//  ContractListView.h
//  
//
//  Created by MBP on 15/7/6.
//
//

#import <UIKit/UIKit.h>

@protocol ContractViewDelegate <NSObject>

- (void)didSelectedContract:(NSInteger)index;

@end

@interface ContractListView : UIView


- (void)showContractList:(NSArray*)lists;

@property (nonatomic,strong)id<ContractViewDelegate>delegate;


@end
