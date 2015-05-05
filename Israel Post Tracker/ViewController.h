//
//  ViewController.h
//  Israel Post Tracker
//
//  Created by Mohammad Abu-Garbeyyeh on 5/5/15.
//  Copyright (c) 2015 Mohammad Abu-Garbeyyeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *packageNumberField;
- (IBAction)trackPackage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *packageStatusField;
@property (weak, nonatomic) IBOutlet UILabel *packageTypeField;

@end

