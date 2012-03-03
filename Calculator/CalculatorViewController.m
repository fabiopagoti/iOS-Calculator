//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Fábio Pagoti on 12-01-31.
//  Copyright (c) 2012 Inlingua Vancouver Granville. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

@property (weak, nonatomic) IBOutlet UILabel *history;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringAFloatNumber;
@property (nonatomic, strong) CalculatorBrain * brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userIsInTheMiddleOfEnteringAFloatNumber = _userIsInTheMiddleOfEnteringAFloatNumber;
@synthesize brain = _brain;

-(CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (void) updateHistory:(NSString *)newElement
{
    if (self.history.text == nil) {
        self.history.text = newElement;
    } else {
        self.history.text = [[self.history.text stringByAppendingString:@" "] stringByAppendingString:newElement];
    }
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString * digit = [sender currentTitle];
    //    NSLog(@"User touched %@", digit);
    
    
    //    UILabel * myDisplay = self.display; // [self display];
    //    NSString * currentDisplayText = myDisplay.text;
    //    NSString * newDisplayString = [currentDisplayText stringByAppendingString:digit];
    //    self.display.text = newDisplayString;
    //    is the same as...
    
    //    self.display.text = [self.display.text stringByAppendingString:digit];
    //    which is the same as...
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];    
    }
    else{
        if (![digit isEqualToString:@"0"]) {
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}

-(void)clearHistoryLabel
{
    self.history.text = @"";
}

- (IBAction)clearHistory {
    [self clearHistoryLabel];
}

- (IBAction)clearCalculator {
    // reset everything
    [self.brain resetBrain];
    [self clearHistoryLabel];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloatNumber = NO;
}

- (IBAction)pointPressed {
    if (!self.userIsInTheMiddleOfEnteringAFloatNumber) {
        self.display.text =  [self.display.text stringByAppendingString:@"."];
        self.userIsInTheMiddleOfEnteringAFloatNumber = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }    
}

- (IBAction)enterPressed {
    // condition necessary because of π operation
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self.brain pushOperand:[self.display.text doubleValue]];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userIsInTheMiddleOfEnteringAFloatNumber = NO;
        [self updateHistory:self.display.text];
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    [self updateHistory:[operation stringByAppendingString:@" ="]];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
}


- (IBAction)swapSignal {
    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.display.text = [NSString stringWithFormat:@"%g", (([self.display.text doubleValue]) * -1)];
}
- (IBAction)backspace {
    if ([self.display.text length] == 1) {
        if (self.display.text != @"0") {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        self.display.text = [self.display.text substringToIndex:([self.display.text length] - 1)];
    }
}


@end
