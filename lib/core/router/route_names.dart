/// 路由名称常量
class RouteNames {
  RouteNames._();

  // 启动与引导相关
  static const String splash = '/';
  static const String privacy = '/privacy';
  static const String landing = '/landing';

  // 认证相关
  static const String login = '/login';
  static const String userInfo = '/user-info';

  // 主框架与底部 4 Tab
  static const String main = '/main';
  static const String discover = '/discover';
  static const String messages = '/messages';
  static const String profile = '/profile';

  // 社交与业务子页面
  static const String userDetail = '/user/:id';
  static const String chat = '/chat/:id';
  static const String giftShop = '/gift-shop';
  static const String giftDetail = '/gift/:id';

  // VIP会员
  static const String vip = '/vip';

  // 隐私设置
  static const String privacySettings = '/privacy-settings';

  // 实名认证
  static const String realNameAuth = '/real-name-auth';

  // 我的照片
  static const String myPhotos = '/my-photos';

  // 帮助与反馈
  static const String helpFeedback = '/help-feedback';

  // 全部热门目的地
  static const String allDestinations = '/destinations/all';
}
