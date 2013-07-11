#import "AWPositionItem.h"

@interface AWGridView : UIView

- (id)initWithFrame:(CGRect)frame gridWidth:(NSUInteger)width;

@property (readonly, nonatomic) AWPositionItem *boundary;
@end
