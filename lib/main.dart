import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 默认的主题色（当设备不支持动态取色时使用）
  static const _defaultLightColorScheme = ColorScheme.light(primary: Colors.blue);
  static const _defaultDarkColorScheme = ColorScheme.dark(primary: Colors.blue);

  // 混合颜色：将背景色与 primary 颜色混合，添加淡淡的主题色调
  Color _blendWithPrimary(Color background, Color primary, double factor) {
    return Color.lerp(background, primary, factor) ?? background;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // 提取到系统主题色（Monet 取色系统生效），并在此调和以满足对比度等规范
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          );
        }

        // 修复浅色模式背景惨白问题：为浅色模式添加更明显的背景色调
        // 使用 surfaceContainerLowest 作为基础，混合 primary 颜色使其带有淡淡的主题色
        final adjustedLightColorScheme = lightColorScheme.copyWith(
          surface: _blendWithPrimary(lightColorScheme.surface, lightColorScheme.primary, 0.08),
          surfaceContainer: _blendWithPrimary(lightColorScheme.surfaceContainer, lightColorScheme.primary, 0.05),
          surfaceContainerLow: _blendWithPrimary(lightColorScheme.surfaceContainerLow, lightColorScheme.primary, 0.03),
          surfaceContainerLowest: _blendWithPrimary(lightColorScheme.surfaceContainerLowest, lightColorScheme.primary, 0.02),
          surfaceContainerHigh: _blendWithPrimary(lightColorScheme.surfaceContainerHigh, lightColorScheme.primary, 0.06),
          surfaceContainerHighest: _blendWithPrimary(lightColorScheme.surfaceContainerHighest, lightColorScheme.primary, 0.08),
        );

        return MaterialApp(
          title: '密码管理',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: adjustedLightColorScheme,
            brightness: Brightness.light,
            useMaterial3: true,
            // 【关键配置】实现类似 Pixel 的原生页面推拉/极客缩放动画
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            brightness: Brightness.dark,
            useMaterial3: true,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode: ThemeMode.system, // 默认跟随系统深色模式/浅色模式
          home: const HomePage(),
        );
      },
    );
  }
}
