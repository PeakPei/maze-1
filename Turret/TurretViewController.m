//
//  TurretViewController.m
//  Turret
//
//  Created by Jesse Chand on 7/15/13.
//  Copyright (c) 2013 Jesse Chand. All rights reserved.
//

#import "TurretViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "SceneMain.h"

@interface TurretViewController ()

@end

@implementation TurretViewController

//Show debug information.
- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView *spriteView = (SKView *) self.view;
    //This is for debug purposes. Comment this out for release.
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
}

//Load the initial scene.
- (void)viewWillAppear:(BOOL)animated
{
    //Create a scene that is the size of the device's screen.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //Create our scene and attach our view to it.
    SceneMain* scene = [[SceneMain alloc] initWithSize:CGSizeMake(screenHeight,screenWidth)];
    SKView *spriteView = (SKView *) self.view;
    [spriteView presentScene: scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
