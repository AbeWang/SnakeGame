#import "AWSnake.h"

static AWSnake *instance = nil;

@implementation AWSnake
{
    NSInteger boundaryRow;
    NSInteger boundaryColumn;
}

+ (AWSnake *)snakeInstance
{
    if (!instance) {
        instance = [[AWSnake alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _currentDirection = AWSnakeDirectionDown;
        [self _init];
    }
    return self;
}

- (void)_init
{
    AWSnakeBodyItem *item1 = [[AWSnakeBodyItem alloc] initWithRow:10 column:12];
    AWSnakeBodyItem *item2 = [[AWSnakeBodyItem alloc] initWithRow:10 column:13];
    AWSnakeBodyItem *item3 = [[AWSnakeBodyItem alloc] initWithRow:10 column:14];
    AWSnakeBodyItem *item4 = [[AWSnakeBodyItem alloc] initWithRow:10 column:15];
    AWSnakeBodyItem *item5 = [[AWSnakeBodyItem alloc] initWithRow:10 column:16];
    _bodyItems = [[NSMutableArray alloc] initWithObjects:item1, item2, item3, item4, item5, nil];
}

- (void)setBoundaryRow:(NSInteger)rowCount column:(NSInteger)columnCount
{
    boundaryRow = rowCount;
    boundaryColumn = columnCount;
}

- (void)moveWithDirection:(AWSnakeDirection)inDirection
{
    if (inDirection == AWSnakeDirectionUp && _currentDirection == AWSnakeDirectionDown) {
        _currentDirection = AWSnakeDirectionDown;
    }
    else if (inDirection == AWSnakeDirectionDown && _currentDirection == AWSnakeDirectionUp) {
        _currentDirection = AWSnakeDirectionUp;
    }
    else if (inDirection == AWSnakeDirectionLeft && _currentDirection == AWSnakeDirectionRight) {
        _currentDirection = AWSnakeDirectionRight;
    }
    else if (inDirection == AWSnakeDirectionRight && _currentDirection == AWSnakeDirectionLeft) {
        _currentDirection = AWSnakeDirectionLeft;
    }
    else {
        _currentDirection = inDirection;
    }
    
    [self.bodyItems removeLastObject];
    AWSnakeBodyItem *firstItem = self.bodyItems[0];
    AWSnakeBodyItem *newItem = [[AWSnakeBodyItem alloc] init];
    switch (_currentDirection) {
        case AWSnakeDirectionUp:
            newItem.row = firstItem.row - 1;
            newItem.column = firstItem.column;
            break;
        case AWSnakeDirectionDown:
            newItem.row = firstItem.row + 1;
            newItem.column = firstItem.column;
            break;
        case AWSnakeDirectionLeft:
            newItem.row = firstItem.row;
            newItem.column = firstItem.column - 1;
            break;
        case AWSnakeDirectionRight:
            newItem.row = firstItem.row;
            newItem.column = firstItem.column + 1;
            break;
    }
    
    if (newItem.row < 0) {
        newItem.row = boundaryRow - 1;
    }
    if (newItem.column < 0) {
        newItem.column = boundaryColumn - 1;
    }
    if (newItem.row >= boundaryRow) {
        newItem.row = 0;
    }
    if (newItem.column >= boundaryColumn) {
        newItem.column = 0;
    }
    
#warning check collision myself
    
    [self.bodyItems insertObject:newItem atIndex:0];
}

- (void)eatFood
{    
}

@end


@implementation AWSnakeBodyItem

- (id)initWithRow:(NSInteger)inRow column:(NSInteger)inColumn
{
    self = [super init];
    if (self) {
        row = inRow;
        column = inColumn;
    }
    return self;
}

@synthesize row, column;
@end
