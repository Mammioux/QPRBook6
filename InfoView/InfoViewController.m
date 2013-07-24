//
//  InfoViewController.m
//  QPRBook
//
//  Created by Teresa Rios-Van Dusen on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

@synthesize delegate;
@synthesize qprsite;


- (void)infoViewControllerDidFinish:(InfoViewController *)controller {
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Initializing QPR View with nib:%@",nibNameOrNil );
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIViewController *anObject = (UIViewController *) self.delegate;
        NSLog(@"Delegate is: %@ and superview is:%@",anObject,self.view.superview);
        

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
    UIViewController *anObject = (UIViewController *) self.delegate;
    NSLog(@"Delegate is: %@",anObject);
    // Do any additional setup after loading the view from its nib.
	[qprsite loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.qprinstitute.com"]]]; 
	

}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"InfoView wil appear");
    UIViewController *anObject = (UIViewController *) self.delegate;
    NSLog(@"Delegate is: %@",anObject);
}

- (void)viewDidUnload
{
    NSLog(@"Unloading InfoView");
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
    NSLog(@"Closing QPR Page");
	[self infoViewControllerDidFinish:self];	
}

@end
