/// 隐私政策内容（HTML格式）
///
/// ⚠️ 提示：当前使用本地写死的隐私政策内容
/// 如需动态获取，请修改 PrivacyPage 中的加载逻辑
class PrivacyContent {
  PrivacyContent._();

  /// 隐私政策 HTML 内容
  static const String htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      padding: 16px;
      font-size: 14px;
    }
    h1 {
      font-size: 20px;
      color: #667eea;
      margin-bottom: 16px;
      text-align: center;
    }
    h2 {
      font-size: 16px;
      color: #333;
      margin-top: 20px;
      margin-bottom: 12px;
      border-left: 4px solid #667eea;
      padding-left: 12px;
    }
    h3 {
      font-size: 14px;
      color: #555;
      margin-top: 16px;
      margin-bottom: 8px;
    }
    p {
      margin-bottom: 12px;
      text-align: justify;
    }
    ul {
      margin-bottom: 12px;
      padding-left: 24px;
    }
    li {
      margin-bottom: 8px;
    }
    .highlight {
      background-color: #f5f5f5;
      padding: 12px;
      border-radius: 8px;
      margin: 12px 0;
    }
    .section {
      margin-bottom: 20px;
    }
    strong {
      color: #667eea;
    }
  </style>
</head>
<body>
  <h1>隐私政策</h1>

  <div class="section">
    <p><strong>更新日期：2024年1月1日</strong></p>
    <p><strong>生效日期：2024年1月1日</strong></p>
  </div>

  <div class="section">
    <p>感谢您使用 Flutter Easy Starter（以下简称"本应用"）。我们非常重视您的个人信息和隐私保护。为了更好地保障您的个人权益，请您在使用本应用前，仔细阅读并充分理解本隐私政策。</p>
  </div>

  <h2>一、我们如何收集您的信息</h2>
  <div class="section">
    <p>我们仅会收集实现产品功能所必需的信息：</p>
    <ul>
      <li><strong>账号信息：</strong>当您注册账号时，我们会收集您的手机号、用户名、密码等信息。</li>
      <li><strong>设备信息：</strong>我们会收集您的设备型号、操作系统版本、唯一设备标识符等信息，用于优化产品体验。</li>
      <li><strong>日志信息：</strong>当您使用我们的服务时，系统会自动记录一些信息，包括使用时长、功能点击记录等。</li>
    </ul>
  </div>

  <h2>二、我们如何使用您的信息</h2>
  <div class="section">
    <p>我们将收集的信息用于以下目的：</p>
    <ul>
      <li>提供、维护和改进我们的服务</li>
      <li>向您发送服务通知和消息</li>
      <li>防止欺诈和不当使用</li>
      <li>遵守法律法规要求</li>
    </ul>
  </div>

  <h2>三、我们如何保护您的信息</h2>
  <div class="section">
    <p>我们采取多种安全措施来保护您的个人信息：</p>
    <ul>
      <li>使用加密技术保护数据传输安全</li>
      <li>建立严格的数据访问权限控制</li>
      <li>定期进行安全审计和风险评估</li>
    </ul>
  </div>

  <h2>四、信息的共享与披露</h2>
  <div class="section">
    <p>我们不会将您的个人信息转让给任何第三方，但以下情况除外：</p>
    <ul>
      <li>获得您的明确同意</li>
      <li>根据法律法规的要求</li>
      <li>为保护我们的合法权益</li>
    </ul>
  </div>

  <h2>五、您的权利</h2>
  <div class="section">
    <p>根据相关法律法规，您拥有以下权利：</p>
    <ul>
      <li>访问和更正您的个人信息</li>
      <li>删除您的个人信息</li>
      <li>撤回同意授权</li>
      <li>注销账号</li>
    </ul>
  </div>

  <h2>六、未成年人保护</h2>
  <div class="section">
    <p>我们非常重视未成年人的个人信息保护。如果您是未满18周岁的未成年人，在使用我们的服务前，请确保已获得监护人的同意。</p>
  </div>

  <h2>七、隐私政策的更新</h2>
  <div class="section">
    <p>我们可能会不时更新本隐私政策。当我们对隐私政策进行重大变更时，我们会在应用内显著位置发布通知。</p>
  </div>

  <h2>八、联系我们</h2>
  <div class="section">
    <p>如果您对本隐私政策有任何疑问或建议，请通过以下方式联系我们：</p>
    <div class="highlight">
      <p>邮箱：privacy@example.com</p>
      <p>电话：400-XXX-XXXX</p>
    </div>
  </div>

  <div class="section">
    <p style="text-align: center; margin-top: 24px; color: #667eea; font-weight: bold;">
      请您仔细阅读并充分理解本隐私政策后，选择是否同意继续使用我们的服务。
    </p>
  </div>
</body>
</html>
  ''';
}
