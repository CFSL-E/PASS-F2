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

        return MaterialApp(
          title: '密码管理',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightDynamic != null
                ? lightDynamic.harmonized().copyWith(
                    // 强制增强背景的色调偏向，避免纯白，提升动态色感
                    surface: lightDynamic.surface.withAlpha(250),
                  )
                : lightColorScheme,
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
            colorScheme: darkDynamic != null
                ? darkDynamic.harmonized().copyWith(
                    surface: darkDynamic.surface.withAlpha(250),
                  )
                : darkColorScheme,
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
