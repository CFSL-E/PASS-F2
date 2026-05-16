import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 【规范】独立的全新 Scaffold，配合大标题滑动效果
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 还原 Pixel 设置页的大标题以及向上滚动自动折叠缩小效果
            SliverAppBar.large(
              title: const Text('设置'),
              // 当此页面向下滑动时，大标题依然保持 MD3 圆润背景或直接融入整体
              backgroundColor: colorScheme.surfaceContainer,
              surfaceTintColor: Colors.transparent,
            ),
          ];
        },
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            _buildSettingsGroup(
              context,
              title: '外观与主题',
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('跟随系统主题'),
                  subtitle: const Text('已自动提取 Android Wallpaper 色彩'),
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildSettingsGroup(
              context,
              title: '本地安全',
              children: [
                ListTile(
                  leading: const Icon(Icons.fingerprint_outlined),
                  title: const Text('生物识别解锁'),
                  subtitle: const Text('使用指纹或面容进入应用'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.password_outlined),
                  title: const Text('更改主密码'),
                  onTap: () {},
                ),
              ],
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildSettingsGroup(
              context,
              title: '关于',
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('版本号'),
                  subtitle: const Text('v1.0.0 (Local Only)'),
                  onTap: () {},
                ),
              ],
            ),
          ],
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
          padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        ...children.map((child) {
          // 为每个列表项添加适当的背景容器，确保在浅色和深色模式下都有良好的对比度
          if (child is ListTile) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: child,
            );
          }
          return child;
        }),
      ],
    );
  }
}
