//
//  SComposePhotosView.h
//
//  Created by Mory on 16/3/12.
//  Copyright © 2016年 MCWonders. All rights reserved.
//


#import "MKComposePhotosView.h"

@implementation MKComposePhotosView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setImage:(UIImage *)image
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.image = image;
    [self addSubview:imageView];
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake(self.frame.size.width - 20, 0, 15, 15);
    [btnDelete setImage:[UIImage imageNamed:@"common_del_circle"] forState:UIControlStateNormal];
    btnDelete.tag = self.index;
    [btnDelete addTarget:self
                  action:@selector(deletePhotoItem:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDelete];

}

///删除图片的代理方法
-(void)deletePhotoItem:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(MKComposePhotosView:didSelectDeleBtnAtIndex:)]) {
        [self.delegate MKComposePhotosView:self didSelectDeleBtnAtIndex:sender.tag];
    }
}

@end
