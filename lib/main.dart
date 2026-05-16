import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

/// 增强颜色色调偏向，避免纯中性灰白
/// 将基础色与主题色混合，使背景带有轻微的色调倾向
Color _enhanceColorTint(Color base, Color tint) {
  // 提取 tint 的色相和饱和度，轻微混合到 base 中
  // 使用 HSLColor 进行更精确的色调控制
  final hslBase = HSLColor.fromColor(base);
  final hslTint = HSLColor.fromColor(tint);
  
  // 混合 5-10% 的主题色调到基础色中，增强动态色感
  // 同时略微提高饱和度，使背景不完全是灰白色
  return hslBase
      .withHue(hslTint.hue)
      .withSaturation((hslBase.saturation + hslTint.saturation * 0.08).clamp(0.0, 1.0))
      .withLightness(hslBase.lightness)
      .toColor()
      .withAlpha(245); // 轻微降低不透明度，增强层次感
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 默认的主题色（当设备不支持动态取色时使用）
  static const _defaultLightColorScheme = ColorScheme.light(primary: Colors.blue);
  static const _defaultDarkColorScheme = ColorScheme.dark(primary: Colors.blue);

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

        // 强制增强背景的色调偏向，避免纯白，提升动态色感
        // 通过微调 surface 颜色使其更偏向种子的色调，而不是纯中性灰白
        final enhancedLightColorScheme = lightColorScheme.copyWith(
          surface: _enhanceColorTint(lightColorScheme.surface, lightColorScheme.primary),
          surfaceContainer: _enhanceColorTint(lightColorScheme.surfaceContainer, lightColorScheme.primary),
          surfaceContainerLow: _enhanceColorTint(lightColorScheme.surfaceContainerLow, lightColorScheme.primary),
          surfaceContainerHigh: _enhanceColorTint(lightColorScheme.surfaceContainerHigh, lightColorScheme.primary),
          surfaceContainerHighest: _enhanceColorTint(lightColorScheme.surfaceContainerHighest, lightColorScheme.primary),
        );
        final enhancedDarkColorScheme = darkColorScheme.copyWith(
          surface: _enhanceColorTint(darkColorScheme.surface, darkColorScheme.primary),
          surfaceContainer: _enhanceColorTint(darkColorScheme.surfaceContainer, darkColorScheme.primary),
          surfaceContainerLow: _enhanceColorTint(darkColorScheme.surfaceContainerLow, darkColorScheme.primary),
          surfaceContainerHigh: _enhanceColorTint(darkColorScheme.surfaceContainerHigh, darkColorScheme.primary),
          surfaceContainerHighest: _enhanceColorTint(darkColorScheme.surfaceContainerHighest, darkColorScheme.primary),
        );

        return MaterialApp(
          title: '密码管理',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: enhancedLightColorScheme,
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
            colorScheme: enhancedDarkColorScheme,
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
