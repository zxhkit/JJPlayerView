//
//  JJVideoTableViewCell.m
//  iOS_Tools
//
//  Created by zhouxuanhe on 2020/9/27.
//  Copyright © 2020 播呗网络. All rights reserved.
//

#import "JJVideoTableViewCell.h"

@interface JJVideoTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImgView;

@property (nonatomic, strong) UILabel *authorLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *coverImgView;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *playButton;


@end
@implementation JJVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 初始化界面
- (void)setupUI{
    
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.coverImgView];
    [self.contentView addSubview:self.playButton];
    [self.contentView addSubview:self.detailLabel];

    
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).mas_offset(16);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).mas_offset(10);
        make.right.equalTo(self.contentView).mas_offset(-16);
        make.top.equalTo(self.headerImgView).mas_offset(-1);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.authorLabel);
        make.bottom.equalTo(self.headerImgView);
    }];
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.headerImgView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(300);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.coverImgView.mas_bottom).mas_offset(10);
        make.bottom.equalTo(self.contentView).mas_offset(-10);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    
}


- (void)setModel:(JJVideoModel *)model{
    _model = model;
    self.titleLabel.text = _model.title;
    self.coverImgView.image = [UIImage imageNamed:_model.imageName];
    self.detailLabel.text = _model.detailText;
    
}




- (void)playButtonAction:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(jj_videoTableViewCellDidPlayButtonInCell:)]) {
        [self.delegate jj_videoTableViewCellDidPlayButtonInCell:self];
    }
    
}







- (UIImageView *)headerImgView{
    if (_headerImgView == nil) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"local_4"];
        _headerImgView.contentMode = UIViewContentModeScaleToFill;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.layer.cornerRadius = 20;
    }
    return _headerImgView;
}

- (UILabel *)authorLabel{
    if (_authorLabel == nil) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:14];
        _authorLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _authorLabel.text = @"作者:每日一语";
    }
    return _authorLabel;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UIImageView *)coverImgView{
    if (_coverImgView == nil) {
        _coverImgView = [[UIImageView alloc] init];
    }
    return _coverImgView;
}

- (UILabel *)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _detailLabel;
}

- (UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageWithName:@"JJPlayButton"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageWithName:@"JJPauseButton"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}













@end
