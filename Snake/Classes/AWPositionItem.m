#import "AWPositionItem.h"

@implementation AWPositionItem

- (id)initWithRow:(NSInteger)inRow column:(NSInteger)inColumn
{
    self = [super init];
    if (self) {
        _row = inRow;
        _column = inColumn;
    }
    return self;
}

@end
