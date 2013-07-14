#import "AWSnakeViewController.h"
#import "AWGameGridView.h"
#import "AWSnake.h"

#define MOVE_SPEED 0.3

@implementation AWSnakeViewController
{
    NSTimer *timer;
    AWSnakeDirection snakeDirection;
}

- (void)dealloc
{
    [timer invalidate];
}
- (void)loadView
{
    [super loadView];
    AWGameGridView *gridView = [[AWGameGridView alloc] initWithFrame:self.view.bounds gridWidth:20.0];
    self.view = gridView;
    
	[AWSnake snakeInstance].boundary = gridView.boundary;
    snakeDirection = [AWSnake snakeInstance].currentDirection;
    
    UISwipeGestureRecognizer *upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(up:)];
    [upGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:upGestureRecognizer];
    UISwipeGestureRecognizer *downGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(down:)];
    [downGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downGestureRecognizer];
    UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(left:)];
    [leftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftGestureRecognizer];
    UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(right:)];
    [rightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightGestureRecognizer];

	timer = [NSTimer scheduledTimerWithTimeInterval:MOVE_SPEED target:self selector:@selector(snakeMove) userInfo:nil repeats:YES];
}

#pragma mark - Actions

- (void)snakeMove
{
    [[AWSnake snakeInstance] moveWithDirection:snakeDirection completionHandler:^(NSError *error) {
		if (error) {
			[timer invalidate];
			if ([error code] == AWSnakeErrorBodyCollision) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Restart", nil];
				[alert show];
			}
			return;
		}
        [self.view setNeedsDisplay];
	}];
}
- (void)up:(UISwipeGestureRecognizer *)gr
{
    snakeDirection = AWSnakeDirectionUp;
}
- (void)down:(UISwipeGestureRecognizer *)gr
{
    snakeDirection = AWSnakeDirectionDown;
}
- (void)left:(UISwipeGestureRecognizer *)gr
{
    snakeDirection = AWSnakeDirectionLeft;
}
- (void)right:(UISwipeGestureRecognizer *)gr
{
    snakeDirection = AWSnakeDirectionRight;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[AWSnake snakeInstance] reset];
    snakeDirection = [AWSnake snakeInstance].currentDirection;
	timer = [NSTimer scheduledTimerWithTimeInterval:MOVE_SPEED target:self selector:@selector(snakeMove) userInfo:nil repeats:YES];
}

@end
