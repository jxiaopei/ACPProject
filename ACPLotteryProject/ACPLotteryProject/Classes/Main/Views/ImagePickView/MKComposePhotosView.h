//
//  SComposePhotosView.h
//
//  Created by Mory on 16/3/12.
//  Copyright © 2016年 MCWonders. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKComposePhotosView;
@protocol MKComposePhotosViewDelegate <NSObject>

-(void)MKComposePhotosView:(MKComposePhotosView *)MKComposePhotosView didSelectDeleBtnAtIndex:(NSInteger)Index;

@end

@interface MKComposePhotosView : UIView
@property (nonatomic,weak)id<MKComposePhotosViewDelegate>delegate;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,assign)NSInteger index;
@end
