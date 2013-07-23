//
//  MainViewController.h
//  QPRBook
//
//  Created by Teresa Rios-Van Dusen on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "ReaderViewController.h"

@interface MainViewController : UIViewController <ReaderViewControllerDelegate, UIActionSheetDelegate> {
}

- (IBAction)showInfo:(id)sender;
- (void) showQPRSite:(id)sender;

@end
