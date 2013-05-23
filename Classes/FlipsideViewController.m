//
//  FlipsideViewController.m
//  QPRBook
//
//  Created by Teresa Rios-Van Dusen on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "PDFScrollView.h"
#import "InfoViewController.h"
#import "QPRBookAppDelegate.h"


@implementation FlipsideViewController

@synthesize singleSV;
@synthesize infoVC;



- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor]; 
    //read current page from defaults
    pageNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPage"];
    self.bookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"];
    // calculate totalPages from pdf file
  
    // Open the PDF document
    
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    NSURL *pdfURL; 
    if ([lang compare:@"English"] == NSOrderedSame) {
        pdfURL = [[NSBundle mainBundle] URLForResource:@"Forever_Decision.pdf" withExtension:nil];
        self.navigationItem.title = @"Forever Decision";
    } else {
        pdfURL = [[NSBundle mainBundle] URLForResource:@"Decisión para siempre.pdf" withExtension:nil];
        self.navigationItem.title = @"Decision para Siempre";
    }
    pdf = CGPDFDocumentCreateWithURL(( CFURLRef)CFBridgingRetain(pdfURL));
    
    totalPages = CGPDFDocumentGetNumberOfPages (pdf);
    if (totalPages > 0) {
        NSLog(@"Total Pages %d",totalPages);
    }
    // Add the PDFScrollView
    PDFScrollView *sv = [[PDFScrollView alloc] init];
    CGPDFPageRef PDFPage = CGPDFDocumentGetPage(pdf, pageNumber);
    [sv setPDFPage:PDFPage];
    [singleSV  addSubview:sv];
    
    //add gesture recognizer to accept right swipe motion to change pages
    
    UIGestureRecognizer *recognizer;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	[self.view addGestureRecognizer:recognizer];
    
    // Create a swipe gesture recognizer to recognize left swipes.
    UISwipeGestureRecognizer *lrec;
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    lrec = (UISwipeGestureRecognizer *) recognizer;
    lrec.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:lrec];
    
}
/*
-(PDFScrollView*)quartzView
{
	if(quartzView == nil)
	{
		quartzView = [[PDFScrollView alloc] initWithFrame:CGRectZero];
	}
	return quartzView;
}
*/
-(void)redraw
{
    NSArray *subviews = [singleSV subviews];
    PDFScrollView *sv = [subviews objectAtIndex:0];
    [sv removeFromSuperview];
    
    // Add the PDFScrollView
    sv = [[PDFScrollView alloc] init];
    
    [singleSV  addSubview:sv];
    
}

- (IBAction)done:(id)sender {
    // save current page
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)nextPage:(id)sender {
    pageNumber = (++pageNumber) >= totalPages ? totalPages : pageNumber;
    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"currentPage"];
    [self redraw];
    //NSLog(@"current page: %d",pageNumber);
    
}
- (IBAction)previousPage:(id)sender{
    pageNumber = --pageNumber <= 1 ? 1 : pageNumber;
    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"currentPage"];
    [self redraw];
    //NSLog(@"current page: %d",pageNumber);    
}
- (IBAction)endBook:(id)sender{
    pageNumber = totalPages;
    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"currentPage"];
    [self redraw];
    NSLog(@"current page: %d",pageNumber);
}
- (IBAction)startBook:(id)sender{
    pageNumber = 1;
    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"currentPage"];
    [self redraw];
    NSLog(@"current page: %d",pageNumber);
}

- (IBAction)medbag:(id)sender {
    //NSLog(@"Help actions");
	UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:@"For help and more information:"
                                                            delegate:self cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:	@"I need HELP",
                                 @"About QPR",
                                 nil];
	
	// use the same style as the nav bar
	styleAlert.actionSheetStyle = self.navigationController.navigationBar.barStyle;
	[styleAlert showInView:self.view.window];
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Change the navigation bar style, also make the status bar match with it
	switch (buttonIndex)
	{
		case 0:
		{
			// Show page with numbers to call
			//NSLog(@"I Need HELP");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In Crisis Now?" message:@"Please call 1-800-273-TALK (1-800-273-8255) or 1-800-SUICIDE (1-800-784-2433) "
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
			break;
		}
		case 1:
		{
			// Show QPR Institute page
			//NSLog(@"About QPR");  
            //[self dismissModalViewControllerAnimated:YES];
            
                // gain access to the delegate and send a message to switch to a particular view.
            InfoViewController *controller = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil ];
            //QPRBookAppDelegate *myDelegate = (QPRBookAppDelegate *)[[UIApplication sharedApplication] delegate];
            //[self.navigationController pushViewController:controller animated:YES ];
            
            [self presentViewController:controller animated:YES completion:nil];
            
			break;
		}
	}
}


// process button pressed on alert view


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // Call emergency phone number
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18002738255"]];
        
    }
}
- (IBAction)annotation:(id)sender{
    NSLog(@"Capture annotation for page");
}

- (IBAction)flipLanguage:(id)sender{
    NSLog(@"Switch from English to Spanish and vice-versa");
    UIBarButtonItem *lang = sender;
    
    if ([lang.title compare:@"English"] == NSOrderedSame ) {
        lang.title = @"Spanish";
        [[NSUserDefaults standardUserDefaults] setValue:@"Spanish" forKey:@"language"];

    } else {
        lang.title = @"English";
        [[NSUserDefaults standardUserDefaults] setValue:@"English" forKey:@"language"];
    }

    [self redraw];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(void) viewWillAppear:(BOOL)animated {
    
    if (singleSV == nil) {
        // Create our PDFScrollView and add it to the view controller.
              
    }
   // call PDFScrollView for next page.
    
   // scrollView.maximumZoomScale = 4.0;
   // scrollView.minimumZoomScale = 1.0;
   //	[scrollView setZoomScale:1.0 animated:YES];
   //	self.quartzView.frame = scrollView.bounds;
//	scrollView.contentSize = scrollView.bounds.size;
    
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
    
}



- (void)viewDidAppear:(BOOL)animated {
    
    [self becomeFirstResponder];
    
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    //[self.quartzView release];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark UIScrollView delegate methods
/*
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.quartzView;
}
*/
#pragma mark gesture recognizers

- (void)showImageWithText:(NSString *)string atPoint:(CGPoint)centerPoint {
	
    /*
     Set the appropriate image for the image view, move the image view to the given point, then dispay it by setting its alpha to 1.0.
     */
	NSString *imageName = [string stringByAppendingString:@".png"];
	self.imageView.image = [UIImage imageNamed:imageName];
	self.imageView.center = centerPoint;
	self.imageView.alpha = 1.0;	
}



/*
 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe gesture");
    
	CGPoint location = [recognizer locationInView:self.view];
	[self showImageWithText:@"swipe" atPoint:location];
	
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 220.0;
        [self nextPage:recognizer];
    }
    else {
        location.x += 220.0;
        [self previousPage:recognizer];
    }
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.55];
	self.imageView.alpha = 0.0;
	self.imageView.center = location;
	[UIView commitAnimations];
}

#pragma mark motion shake event
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    NSLog(@"motion event received");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    
    NSLog(@"motion Ended");
    [self startBook:event];
    
}



- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    
}
@end
