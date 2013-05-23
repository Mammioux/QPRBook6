//
//  InfoViewController.h
//  QPRBook
//
//  Created by Teresa Rios-Van Dusen on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoViewControllerDelegate;
@interface InfoViewController : UIViewController    

@property (strong, nonatomic) id <InfoViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIWebView *qprsite;
@end

@protocol InfoViewControllerDelegate
- (void) infoViewControllerDidFinish:(InfoViewController *)controller;
@end


