//
//  ViewController.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/18/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import "ViewController.h"
#import "LabelProvider.h"
#import "ColorProviderProtocol.h"

@interface ViewController () {

    LabelProvider* _ioc_LabelProvider;
    id<ColorProviderProtocol> _ioc_ColorProvider;
}

@property (nonatomic, readonly) LabelProvider* labelProvider;
@property (nonatomic, readonly) id<ColorProviderProtocol> colorProvider;

@end

@implementation ViewController

@synthesize labelProvider = _ioc_LabelProvider, colorProvider = _ioc_ColorProvider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [self.colorProvider backgroundColor];
    UILabel* label = [self.labelProvider provideButtonWithFrame:CGRectMake(0, 0, 100, 100)];
    label.center = self.view.center;
	[self.view addSubview:label];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
