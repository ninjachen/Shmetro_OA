//
//  MessageDetailInfo.h
//  ShmetroOA
//
//  Created by gisteam on 6/13/13.
//
//

#import <Foundation/Foundation.h>

@interface MessageDetailInfo : NSObject{
    NSString *mid;
    NSString *title;
    NSString *pubDate;
    NSString *source;
    NSString *content;
    NSString*attachId;
    NSString *app;
}
@property(nonatomic,retain)NSString *mid;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *pubDate;
@property(nonatomic,retain)NSString *source;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *attachId;
@property(nonatomic,retain)  NSString *app;

@end
