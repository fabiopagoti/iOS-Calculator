//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Fábio Pagoti on 12-01-31.
//  Copyright (c) 2012 Inlingua Vancouver Granville. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray * programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

// set implementation of synthesize to be used
//-(void)setOperandStack:(NSMutableArray *)anArray
//{
//    _operandStack = anArray;
//}

-(NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void) pushOperand:(double)operand
{
    NSNumber * operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

//-(double)popOperand
//{
//    NSNumber * operandObject = [self.programStack lastObject];
//    if (self.programStack) {
//        [self.programStack removeLastObject];
//    }
//    return [operandObject doubleValue];
//    
//}

- (double) performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}


- (void) resetBrain
{
    self.programStack = nil;
}

// 2nd assignment

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }else if ([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffProgramStack:stack]);
        }else if ([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffProgramStack:stack]);
        }else if ([@"tan" isEqualToString:operation]){
            result = tan([self popOperandOffProgramStack:stack]);
        }else if ([@"∏" isEqualToString:operation]){
            result = M_PI;
        }else if ([@"sqrt" isEqualToString:operation]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        }else if ([@"log" isEqualToString:operation]){
            result = log([self popOperandOffProgramStack:stack]);
        }else if ([@"e" isEqualToString:operation]){
            result = 2.718281828;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}



@end

