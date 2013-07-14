#import "AWSnake.h"
#import "AWFood.h"

NSString *const kSnakeErrorDomain = @"kSnakeErrorDomain";

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
    _bodyItems = [[NSMutableArray alloc] init];
    [self _resetBody];
}

- (void)reset
{
	[self _resetBody];
	_currentDirection = AWSnakeDirectionDown;
}

- (void)_resetBody
{
    [_bodyItems removeAllObjects];
    for (NSUInteger i = 0; i < 5; i++) {
        AWPositionItem *bodyItem = [[AWPositionItem alloc] initWithRow:0 column:i + 3];
        [_bodyItems addObject:bodyItem];
    }
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

	// Check new item boundary
    if (newItem.row < 0) {
        newItem.row = _boundary.row - 1;
    }
    else if (newItem.row >= _boundary.row) {
        newItem.row = 0;
    }
    if (newItem.column < 0) {
        newItem.column = _boundary.column - 1;
    }
    else if (newItem.column >= _boundary.column) {
        newItem.column = 0;
    }
    
	// Check collision
	for (AWPositionItem *item in self.bodyItems) {
		if (item.row == newItem.row && item.column == newItem.column) {
			error = [NSError errorWithDomain:kSnakeErrorDomain code:AWSnakeErrorBodyCollision userInfo:nil];
            inHandler(error);
            return;
		}
	}

	// Check food
	AWPositionItem *foodItem = [AWFood foodInstance].position;
	if (newItem.row == foodItem.row && newItem.column == foodItem.column) {
		// Random position
        NSInteger foodRow = rand() % _boundary.row;
        NSInteger foodColumn = rand() % _boundary.column;
foodRandom:
        for (AWPositionItem *item in _bodyItems) {
            if (foodRow == item.row && foodColumn == item.column) {
                foodRow = rand() % _boundary.row;
                foodColumn = rand() % _boundary.column;
                goto foodRandom;
            }
        }
        [AWFood foodInstance].position.row = foodRow;
        [AWFood foodInstance].position.column = foodColumn;
	}
    else {
        // Remove last item
		[self.bodyItems removeLastObject];
    }
    // Insert new item to head
    [self.bodyItems insertObject:newItem atIndex:0];
    inHandler(error);
}

@end
