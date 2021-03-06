#import "TGCommandPanelCell.h"

#import "TGFont.h"

#import "TGBotComandInfo.h"

#import "TGLetteredAvatarView.h"

#import "TGFont.h"
#import "TGImageUtils.h"

#import "TGUser.h"

@interface TGCommandPanelCell ()
{
    TGLetteredAvatarView *_avatarView;
    UILabel *_titleLabel;
    UILabel *_descriptionLabel;
}

@end

@implementation TGCommandPanelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        UIColor *backgroundColor = [UIColor whiteColor];
        UIColor *nameColor = [UIColor blackColor];
        UIColor *usernameColor = [UIColor blackColor];
        UIColor *selectionColor = TGSelectionColor();
        
        self.backgroundColor = backgroundColor;
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = backgroundColor;
        self.backgroundView.opaque = false;
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = selectionColor;
        
        _avatarView = [[TGLetteredAvatarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [_avatarView setSingleFontSize:14.0f doubleFontSize:14.0f useBoldFont:false];
        _avatarView.fadeTransition = true;
        [self.contentView addSubview:_avatarView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = nameColor;
        _titleLabel.font = TGMediumSystemFontOfSize(14.0f);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = usernameColor;
        _descriptionLabel.font = TGSystemFontOfSize(14.0f);
        _descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_descriptionLabel];
    }
    return self;
}

- (void)setCommandInfo:(TGBotComandInfo *)commandInfo user:(TGUser *)user
{
    if (user == nil)
        _avatarView.hidden = true;
    else
    {
        _avatarView.hidden = false;
        NSString *avatarUrl = user.photoUrlSmall;
        
        CGFloat diameter = 32.0f;
        
        static UIImage *placeholder = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^
        {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), false, 0.0f);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //!placeholder
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillEllipseInRect(context, CGRectMake(0.0f, 0.0f, diameter, diameter));
            CGContextSetStrokeColorWithColor(context, UIColorRGB(0xd9d9d9).CGColor);
            CGContextSetLineWidth(context, 1.0f);
            CGContextStrokeEllipseInRect(context, CGRectMake(0.5f, 0.5f, diameter - 1.0f, diameter - 1.0f));
            
            placeholder = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
        
        if (avatarUrl.length != 0)
        {
            _avatarView.fadeTransitionDuration = 0.3;
            if (![avatarUrl isEqualToString:_avatarView.currentUrl])
                [_avatarView loadImage:avatarUrl filter:@"circle:32x32" placeholder:placeholder];
        }
        else
        {
            [_avatarView loadUserPlaceholderWithSize:CGSizeMake(diameter, diameter) uid:user.uid firstName:user.firstName lastName:user.lastName placeholder:placeholder];
        }
    }
    
    _titleLabel.text = [[NSString alloc] initWithFormat:@"/%@", commandInfo.command];
    _descriptionLabel.text = commandInfo.commandDescription;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    
    _avatarView.frame = CGRectMake(7.0f + TGRetinaPixel, TGRetinaFloor((boundsSize.height - _avatarView.frame.size.height) / 2.0f), _avatarView.frame.size.width, _avatarView.frame.size.height);
    
    CGFloat leftInset = _avatarView.hidden ? 6.0f : 51.0f;
    CGFloat spacing = 6.0f;
    CGFloat rightInset = 6.0f;
    
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font];
    titleSize.width = CGCeil(MIN((boundsSize.width - leftInset - rightInset) * 3.0f / 4.0f, titleSize.width));
    titleSize.height = CGCeil(titleSize.height);
    
    CGSize descriptionSize = [_descriptionLabel.text sizeWithFont:_descriptionLabel.font];
    descriptionSize.width = CGCeil(MIN(boundsSize.width - leftInset - rightInset - titleSize.width - spacing, descriptionSize.width));
    
    _titleLabel.frame = CGRectMake(leftInset, CGFloor((boundsSize.height - titleSize.height) / 2.0f), titleSize.width, titleSize.height);
    _descriptionLabel.frame = CGRectMake(leftInset + titleSize.width + spacing, CGFloor((boundsSize.height - descriptionSize.height) / 2.0f), descriptionSize.width, descriptionSize.height);
}

@end
