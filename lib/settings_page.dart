import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 【规范】独立的全新 Scaffold，配合大标题滑动效果
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 还原 Pixel 设置页的大标题以及向上滚动自动折叠缩小效果
            SliverAppBar.large(
              title: const Text('设置'),
              // 当此页面向下滑动时，大标题依然保持 MD3 圆润背景或直接融入整体
              backgroundColor: colorScheme.surfaceContainerLow,
            ),
          ];
        },
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _buildSettingsGroup(
              context,
              title: '外观与主题',
              children: [
                _buildSettingsCard(
                  context,
                  leading: Icon(Icons.palette_outlined, color: colorScheme.primary),
                  title: '跟随系统主题',
                  subtitle: '已自动提取 Android Wallpaper 色彩',
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
            _buildSettingsGroup(
              context,
              title: '本地安全',
              children: [
                _buildSettingsCard(
                  context,
                  leading: Icon(Icons.fingerprint_outlined, color: colorScheme.primary),
                  title: '生物识别解锁',
                  subtitle: '使用指纹或面容进入应用',
                  onTap: () {},
                ),
                _buildSettingsCard(
                  context,
                  leading: Icon(Icons.password_outlined, color: colorScheme.primary),
                  title: '更改主密码',
                  onTap: () {},
                ),
              ],
            ),
            _buildSettingsGroup(
              context,
              title: '关于',
              children: [
                _buildSettingsCard(
                  context,
                  leading: Icon(Icons.info_outline, color: colorScheme.primary),
                  title: '版本号',
                  subtitle: 'v1.0.0 (Local Only)',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建带 Card 包裹的设置项，确保与背景有明显区分
  Widget _buildSettingsCard(
    BuildContext context, {
    required Widget leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 0,
        // 使用 surfaceContainerHigh 确保卡片比背景深，形成清晰层级
        color: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ListTile(
              leading: leading,
              title: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: colorScheme.onSurfaceVariant)) : null,
              trailing: trailing,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(BuildContext context, {required String title, required List<Widget> children}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
