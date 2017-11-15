//
//  UITextField+Addition.m
//  QDB
//
//  Created by MyBook on 17/1/18.
//  Copyright © 2017年 whj. All rights reserved.
//

#import "UITextField+Addition.h"

@implementation UITextField (Addition)

- (void)LengthLimited:(NSInteger) length
{
    self.tag = length;
    [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldValueChanged:(UITextField *)textField
{
    if(textField.text.length>self.tag)
    {
        textField.text = [textField.text substringToIndex:self.tag];
    }
}
@end
