//
//  MainViewController.m
//  QPRBook
//
//  Created by Teresa Rios-Van Dusen on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "InfoViewController.h"


@implementation MainViewController


- (void)infoViewControllerDidFinish:(UIViewController *)controller {
    
	[self dismissViewControllerAnimated:YES completion:nil];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    [self performSelectorOnMainThread:@selector(medbag:) withObject:nil waitUntilDone:NO];
}


- (IBAction)showInfo:(id)sender {
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
	NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to last PDF file

    UIButton *b = sender;
    if ([b.titleLabel.text compare:@"Open Book"] == NSOrderedSame) {

        filePath = [pdfs objectAtIndex:1];
        // set language as English
        [[NSUserDefaults standardUserDefaults] setValue:@"English" forKey:@"language"];
    } else {

        // set language as Spanish
        [[NSUserDefaults standardUserDefaults] setValue:@"Spanish" forKey:@"language"];
        filePath = [pdfs objectAtIndex:0];
    }
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
        UIImage *image = [UIImage imageNamed:@"79-medical-bag.png"];
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithImage:image
                                                           landscapeImagePhone:image
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self action:@selector(medbag:)];
 		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document withActionButton:actionButton];
        //[actionButton setTarget:readerViewController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(medbag:)
                                                     name:@"MEDBAG"
                                                   object:readerViewController];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
	}

}

// action to call for help
- (IBAction)medbag:(id)sender {
    NSLog(@"In medbag: sender is %@ and view is %@",sender, self.view);
	UIActionSheet *styleAlert = [[UIActionSheet alloc] initWithTitle:@"For help and more information:"
                                                            delegate:self cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:	@"I need HELP",
                                 @"About QPR",
                                 nil];
	
	// use the same style as the nav bar
	styleAlert.actionSheetStyle =  UIActionSheetStyleDefault;
    for (UIView *view in self.view.subviews) {
        NSLog(@"SubView is %@", view);
    }
    if (sender){
        [styleAlert showInView:[(MainViewController *)[(UIBarButtonItem *)sender target] view]];
    } else {
        [styleAlert showInView:[UIApplication sharedApplication].delegate.window];
    }
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//
//- (void) showQPRSite:(id)sender {
//    NSLog(@"Show QPR Site");
//}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Change the navigation bar style, also make the status bar match with it
	switch (buttonIndex)
	{
		case 0:
		{
			// Show page with numbers to call

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In Crisis Now?" message:@"Please call 1-800-273-TALK (1-800-273-8255) or 1-800-SUICIDE (1-800-784-2433) "
                                                           delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles: @"OK",nil];
            [alert show];
			break;
		}
		case 1:
		{            
            // gain access to the delegate and send a message to switch to a particular view.
//            InfoViewController *controller = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil ];
//            controller.delegate = self;
//            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            controller.modalPresentationStyle = UIModalPresentationFullScreen;
//            UIWindow *rvc = [UIApplication sharedApplication].keyWindow;
//            [rvc addSubview:controller.view];
//            
//            //[rvc.rootViewController presentViewController:controller animated:YES completion:NULL];
//            [self.navigationController pushViewController:controller animated:YES];
            NSLog(@"Going to Perform Segue and superview is:%@",self.view.superview);
            [self performSegueWithIdentifier:@"ShowQPRSite" sender:self.navigationController];
			break;
		}
	}
}
// process button pressed on alert view


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        // Call emergency phone number
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18002738255"]];
        
    }
}

- (IBAction)done:(id)sender {
    // save current page
    NSLog(@"Closing QPR Page inside MainViewController");
	[self infoViewControllerDidFinish:(InfoViewController *)self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing for Segue: %@",[segue identifier]);
    if ([[segue identifier] isEqualToString:@"ShowQPRSite"])
    {
        InfoViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc = [vc initWithNibName:@"InfoViewController" bundle:nil ];

    }
}

@end
