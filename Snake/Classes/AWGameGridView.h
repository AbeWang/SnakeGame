#import "AWPositionItem.h"

@interface AWGameGridView : UIView

- (id)initWithFrame:(CGRect)frame gridWidth:(NSUInteger)width;

@property (readonly, nonatomic) AWPositionItem *boundary;
@end
