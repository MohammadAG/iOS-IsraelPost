//
//  ViewController.m
//  Israel Post Tracker
//
//  Created by Mohammad Abu-Garbeyyeh on 5/5/15.
//  Copyright (c) 2015 Mohammad Abu-Garbeyyeh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.packageNumberField becomeFirstResponder];
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_used_number"];
    if (number) {
        self.packageNumberField.text = number;
        [self trackPackage:self.packageNumberField];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)trackPackage:(id)sender {
    NSString *packageNumber = [self.packageNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    /**
     * Valid package numbers are either 8 or 13 chars long with the following format:
     * For 8 chars long: 12345678 - 8 integers for local mail.
     * For 13 chars long: XX123456789XX following the standard EMS format.
     */
    if (packageNumber.length != 13 && packageNumber.length != 8) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid number" message:@"Incorrect tracking number!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    
    [self.packageNumberField resignFirstResponder];
    
    // Cache it cause why not
    [[NSUserDefaults standardUserDefaults] setObject:packageNumber forKey:@"last_used_number"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.israelpost.co.il/itemtrace.nsf/trackandtraceJSON?OpenAgent&lang=en&itemcode=%@", packageNumber];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          self.packageTypeField.text = [dictionary objectForKey:@"typename"];
                                          self.packageStatusField.text = [dictionary objectForKey:@"itemcodeinfo"];
                                          
                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                      });
                                  }];
    
    [task resume];
}

@end
