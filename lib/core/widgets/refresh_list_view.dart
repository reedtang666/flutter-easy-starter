import 'package:flutter/material.dart';
import 'package:flutter_easy_starter/core/widgets/empty_widgets.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// 刷新控制器封装
class RefreshListController {
  final RefreshController controller = RefreshController();

  /// 刷新完成
  void refreshCompleted() {
    controller.refreshCompleted();
  }

  /// 加载完成
  void loadComplete({bool noMore = false}) {
    if (noMore) {
      controller.loadNoData();
    } else {
      controller.loadComplete();
    }
  }

  /// 刷新失败
  void refreshFailed() {
    controller.refreshFailed();
  }

  /// 加载失败
  void loadFailed() {
    controller.loadFailed();
  }

  /// 释放
  void dispose() {
    controller.dispose();
  }
}

/// 下拉刷新 + 上拉加载列表
///
/// 使用示例：
/// ```dart
/// RefreshListView(
///   controller: refreshController,
///   itemCount: items.length,
///   itemBuilder: (context, index) => ItemWidget(item: items[index]),
///   onRefresh: () async {
///     // 刷新数据
///     refreshController.refreshCompleted();
///   },
///   onLoad: () async {
///     // 加载更多
///     refreshController.loadComplete();
///   },
///   emptyWidget: EmptyWidget(title: '暂无数据'),
/// )
/// ```
class RefreshListView extends StatelessWidget {
  final RefreshListController controller;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoad;
  final Widget? emptyWidget;
  final Widget? separator;
  final EdgeInsets? padding;
  final bool enablePullUp;
  final bool enablePullDown;
  final ScrollPhysics? physics;

  const RefreshListView({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoad,
    this.emptyWidget,
    this.separator,
    this.padding,
    this.enablePullUp = true,
    this.enablePullDown = true,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    // 空数据状态
    if (itemCount == 0 && emptyWidget != null) {
      return SmartRefresher(
        controller: controller.controller,
        enablePullUp: false,
        enablePullDown: enablePullDown,
        onRefresh: onRefresh,
        child: emptyWidget,
      );
    }

    return SmartRefresher(
      controller: controller.controller,
      enablePullUp: enablePullUp && itemCount > 0,
      enablePullDown: enablePullDown,
      onRefresh: onRefresh,
      onLoading: onLoad,
      header: const ClassicHeader(
        refreshingText: '刷新中...',
        idleText: '下拉刷新',
        releaseText: '松开刷新',
        completeText: '刷新完成',
        failedText: '刷新失败',
      ),
      footer: const ClassicFooter(
        loadingText: '加载中...',
        idleText: '上拉加载更多',
        canLoadingText: '松开加载更多',
        noDataText: '没有更多了',
        failedText: '加载失败',
      ),
      child: separator != null
          ? ListView.separated(
              padding: padding,
              physics: physics,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              separatorBuilder: (context, index) => separator!,
            )
          : ListView.builder(
              padding: padding,
              physics: physics,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            ),
    );
  }
}

/// 简化的刷新列表（带默认空状态和错误状态）
class SimpleRefreshList<T> extends StatelessWidget {
  final RefreshListController controller;
  final List<T> data;
  final Widget Function(T item) itemBuilder;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoad;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final String? emptyTitle;
  final String? emptySubtitle;

  const SimpleRefreshList({
    super.key,
    required this.controller,
    required this.data,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoad,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    this.emptyTitle,
    this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    // 错误状态
    if (hasError && data.isEmpty) {
      return AppErrorWidget(onRetry: onRetry ?? onRefresh);
    }

    // 加载中
    if (isLoading && data.isEmpty) {
      return const LoadingWidget();
    }

    return RefreshListView(
      controller: controller,
      itemCount: data.length,
      itemBuilder: (context, index) => itemBuilder(data[index]),
      onRefresh: onRefresh,
      onLoad: onLoad,
      emptyWidget: EmptyWidget(
        title: emptyTitle ?? '暂无数据',
        subtitle: emptySubtitle,
        onRetry: onRefresh,
      ),
    );
  }
}
