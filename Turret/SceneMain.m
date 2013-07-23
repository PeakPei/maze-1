//
//  SceneMain.m
//  Turret
//
//  Created by Jesse Chand on 7/15/13.
//  Copyright (c) 2013 Jesse Chand. All rights reserved.
//

#import "SceneMain.h"

@interface SceneMain()
@property BOOL contentCreated;
@property SKView* parentView;
@end

@implementation SceneMain

//Update Touches:
//We need to do this for both the initial tap and its movement.
- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    //Grab the touch data.
    UITouch * touch = [touches anyObject];
    CGPoint pos = [touch locationInView:_parentView];
    SKNode *cursorNode = [self childNodeWithName:@"cursorNode"];
    //Set the cursor's position to the finger and update player rotation.
    cursorNode.position = CGPointMake(self.frame.size.width - pos.y, self.frame.size.height - pos.x);
}
- (void)touchesMoved:(NSSet *) touches withEvent:(UIEvent *)event
{
    //Grab the touch data.
    UITouch * touch = [touches anyObject];
    CGPoint pos = [touch locationInView:_parentView];
    SKNode *cursorNode = [self childNodeWithName:@"cursorNode"];
    //Set the cursor's position to the finger and update player rotation.
    cursorNode.position = CGPointMake(self.frame.size.width - pos.y, self.frame.size.height - pos.x);
}

//SCENE: Set up maze.
- (void) spawnMaze
{
    NSLog(@"init");
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity: 10];

    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X", nil] atIndex:0];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"X",@"0",@"0",@"0",@"0",@"0",@"0",@"X", nil] atIndex:1];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"X",@"0",@"0",@"0",@"0",@"0",@"0",@"X", nil] atIndex:2];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"X",@"0",@"X",@"X",@"0",@"0",@"0",@"X", nil] atIndex:3];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"X",@"X",@"X",@"0",@"0",@"0",@"0",@"X", nil] atIndex:4];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"0",@"0",@"X",@"0",@"0",@"X",@"0",@"X", nil] atIndex:5];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"0",@"0",@"X",@"0",@"0",@"X",@"X",@"X", nil] atIndex:6];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"0",@"0",@"0",@"0",@"0",@"X",@"0",@"X", nil] atIndex:7];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"X", nil] atIndex:8];
    [dataArray insertObject:[NSMutableArray arrayWithObjects:@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X", nil] atIndex:9];
    int offx = 16;
    int offy = 16;
    for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        if ([dataArray[i][j]  isEqual: @"X"]) {
            CGPoint pos = CGPointMake(32*i+offx, 32*j+offy);
            [self newWallNode:&pos];
        }
    }
    }
}

//OBJECT: Wall: Prevents player from crossing a path.
- (void)newWallNode:(CGPoint *)pos
{
    SKSpriteNode *wallNode = [[SKSpriteNode alloc] initWithColor:[SKColor redColor] size:CGSizeMake(32,32)];
    wallNode.position = *(pos);
    //Set up the physics of the enemy.
    wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wallNode.size];
    wallNode.physicsBody.dynamic = NO;
    wallNode.physicsBody.affectedByGravity = NO;

    wallNode.name = @"wallNode";
    [self addChild:wallNode];
}

//OBJECT: Cursor: This is drawn under your finger (or mouse). The player points towards it.
- (SKSpriteNode *)newCursorNode
{
    SKSpriteNode *cursorNode = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(8,8)];
    cursorNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    cursorNode.name = @"cursorNode";
    return cursorNode;
}

//OBJECT: Player: Stationary object at the center of the screen.
- (SKSpriteNode *)newPlayerNode
{
    SKSpriteNode *playerNode = [[SKSpriteNode alloc] initWithColor:[SKColor blueColor] size:CGSizeMake(16,16)];
    playerNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:playerNode.size];
    playerNode.physicsBody.dynamic = YES;
    playerNode.physicsBody.affectedByGravity = NO;
    playerNode.physicsBody.allowsRotation = NO;
    playerNode.physicsBody.mass = 100;
    playerNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    playerNode.name = @"playerNode";
    
    return playerNode;
}

//Do on every step after movement:
-(void)didSimulatePhysics
{
    SKNode *playerNode = [self childNodeWithName:@"playerNode"];
    SKNode *cursorNode = [self childNodeWithName:@"cursorNode"];
    float px, py;
    px = cursorNode.position.x - playerNode.position.x;
    py = cursorNode.position.y - playerNode.position.y;
    playerNode.physicsBody.velocity = CGPointMake(px*2, py*2);
}

//Delete the specified object.
- (void)destroyObject: (SKNode *)target
{
    [target removeFromParent];
}

//Populate the scene with objects.
- (void)createSceneContents
{
    //Set uo our scene.
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    //Add our initial objects to the screen.
    [self addChild: [self newPlayerNode]];
    [self addChild: [self newCursorNode]];
    [self spawnMaze];
}

//Begin initial scene loading.
- (void)didMoveToView: (SKView *) view
{
    view = nil;
    if (!self.contentCreated)
    {
        //This is the first thing that gets called in the scene.
        [self createSceneContents];
        self.physicsWorld.contactDelegate = self;
        self.contentCreated = YES;
    }
}

@end