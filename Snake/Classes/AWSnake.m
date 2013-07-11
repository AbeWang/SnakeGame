#import "AWSnake.h"
#import "AWFood.h"

NSString *const kSnakeMoveErrorDomain = @"kSnakeMoveErrorDomain";

static AWSnake *instance = nil;

@implementation AWSnake

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
    AWPositionItem *item1 = [[AWPositionItem alloc] initWithRow:0 column:2];
    AWPositionItem *item2 = [[AWPositionItem alloc] initWithRow:0 column:3];
    AWPositionItem *item3 = [[AWPositionItem alloc] initWithRow:0 column:4];
    AWPositionItem *item4 = [[AWPositionItem alloc] initWithRow:0 column:5];
    AWPositionItem *item5 = [[AWPositionItem alloc] initWithRow:0 column:6];
    _bodyItems = [[NSMutableArray alloc] initWithObjects:item1, item2, item3, item4, item5, nil];
}

- (void)reset
{
	[self.bodyItems removeAllObjects];
	AWPositionItem *item1 = [[AWPositionItem alloc] initWithRow:0 column:2];
    AWPositionItem *item2 = [[AWPositionItem alloc] initWithRow:0 column:3];
    AWPositionItem *item3 = [[AWPositionItem alloc] initWithRow:0 column:4];
    AWPositionItem *item4 = [[AWPositionItem alloc] initWithRow:0 column:5];
    AWPositionItem *item5 = [[AWPositionItem alloc] initWithRow:0 column:6];
	[_bodyItems addObjectsFromArray:@[item1, item2, item3, item4, item5]];
	_currentDirection = AWSnakeDirectionDown;
}

- (void)setBoundary:(AWPositionItem *)positionItem
{
	_boundaryItem = positionItem;
}

- (void)moveWithDirection:(AWSnakeDirection)inDirection completionHandler:(void (^)(NSError*))inHandler
{
	NSError *error = nil;

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

	// Create new item for head
    AWPositionItem *firstItem = self.bodyItems[0];
    AWPositionItem *newItem = [[AWPositionItem alloc] init];
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

	// Check item bounds
    if (newItem.row < 0) {
        newItem.row = _boundaryItem.row - 1;
    }
    if (newItem.column < 0) {
        newItem.column = _boundaryItem.column - 1;
    }
    if (newItem.row >= _boundaryItem.row) {
        newItem.row = 0;
    }
    if (newItem.column >= _boundaryItem.column) {
        newItem.column = 0;
    }
    
	// Check collision
	for (AWPositionItem *item in self.bodyItems) {
		if (item.row == newItem.row && item.column == newItem.column) {
			error = [NSError errorWithDomain:kSnakeMoveErrorDomain code:AWSnakeErrorCode_Move userInfo:nil];
		}
	}

	// Check food
	AWPositionItem *foodItem = [AWFood foodInstance].position;
	if (newItem.row == foodItem.row && newItem.column == foodItem.column) {
		// Add new item
		

		// Random
        NSInteger foodRow = rand() % _boundaryItem.row;
        NSInteger foodColumn = rand() % _boundaryItem.column;
random:
        for (AWPositionItem *item in _bodyItems) {
            if (foodRow == item.row && foodColumn == item.column) {
                foodRow = rand() % _boundaryItem.row;
                foodColumn = rand() % _boundaryItem.column;
                goto random;
            }
        }
        [AWFood foodInstance].position.row = foodRow;
        [AWFood foodInstance].position.column = foodColumn;
	}

	if (!error) {
		// Remove last item
		[self.bodyItems removeLastObject];
		// Insert new item to head
		[self.bodyItems insertObject:newItem atIndex:0];
	}
	inHandler(error);
}

@end
