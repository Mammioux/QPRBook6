//
//  InfoViewController.m
//  QPRBook
//
//  Created by Teresa Rios-Van Dusen on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

- (void)infoViewControllerDidFinish:(InfoViewController *)controller {
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //NSLog(@"initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[qprsite loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.qprinstitute.com"]]]; 

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
     //NSLog(@"View Did Load");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.qprsite loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.qprinstitute.com"]]];
	

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)done:(id)sender {
    // save current page
	[self infoViewControllerDidFinish:self];	
}

@end
