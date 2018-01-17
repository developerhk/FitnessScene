//
//  LoadMoreTableFooterView.h
//  MyApp
//
//  Created by jingyu lu on 9/18/12.
//
//

#import <UIKit/UIKit.h>

typedef enum {
	kLoadMoreStateNormal,
	kLoadMoreStateLoading
} LoadMoreState;

@class LoadMoreTableFooterView;
@protocol LoadMoreTableFooterViewDelegate <NSObject>

// 数据加载完毕 （比如这时可以执行doneLoadMore方法，使当前状态置为normal）
- (void)loadMoreTableFooterViewDataSourceDidFinishedLoading:(LoadMoreTableFooterView *)footerView;

// 发起加载数据请求（比如点击more，或者上提加载的动作）
- (void)loadMoreTableFooterDidTriggerLoading:(LoadMoreTableFooterView *)footerView;

// 当前是否仍在加载数据（当前是否是loading状态）
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)footerView;
@end

@interface LoadMoreTableFooterView : UIView {
	
	BOOL                     _isLoading;
	LoadMoreState            _state;
	UIButton                *_loadingButton;
	UIActivityIndicatorView *_indicator;
}
@property (nonatomic, assign) id<LoadMoreTableFooterViewDelegate> delegate;

// 加载完毕后，将LoadMoreTableFooterView状态置为normal
- (void)doneLoadMore;

// 发起加载请求，通过执行委托方法loadMoreTableFooterViewDataSourceDidFinishedLoading:
- (void)actionLoadMore;

// 当上提到一定程度需要加载更多数据的逻辑在本方法里
- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end
