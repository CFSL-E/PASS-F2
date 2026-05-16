import 'package:flutter/material.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedChip = 0;

  // 模拟数据源
  final List<Map<String, String>> _passwords = [
    {'icon': 'G', 'title': 'Google', 'subtitle': 'zzyzs666@gmail.com'},
    {'icon': 'A', 'title': 'Apple ID', 'subtitle': 'zzyzs666@icloud.com'},
    {'icon': 'G', 'title': 'Github', 'subtitle': 'zzyzs666'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // 顶部搜索栏
              SearchBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // 【规范】使用原生路由执行导航，前往真正的二级页面
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                hintText: '搜索密码',
                hintStyle: WidgetStateProperty.all(
                  TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.8), fontSize: 16)
                ),
                elevation: WidgetStateProperty.all(0),
                backgroundColor: WidgetStateProperty.all(
                   // 类似截图中的淡色背景
                  colorScheme.surfaceContainerHigh.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              
              // 筛选标签行
              Row(
                children: [
                  _buildFilterChip('全部', 0, colorScheme),
                  const SizedBox(width: 8),
                  _buildFilterChip('最近添加', 1, colorScheme),
                  const SizedBox(width: 8),
                  _buildFilterChip('常用', 2, colorScheme),
                ],
              ),
              const SizedBox(height: 20),
              
              // 密码列表区
              Expanded(
                child: ListView.builder(
                  itemCount: _passwords.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = _passwords[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        elevation: 0,
                        // 还原截图中的扁平大圆角淡色气泡卡片设计
                        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: colorScheme.primaryContainer,
                                foregroundColor: colorScheme.onPrimaryContainer,
                                child: Text(
                                  item['icon']!,
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                                ),
                              ),
                              title: Text(
                                item['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                item['subtitle']!,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // 底部 FAB 按钮 - 大气矩形圆角方案 (MD3 特征)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 2,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  // 构建统一的视觉 Chip (还原截图中的圆角小巧设计)
  Widget _buildFilterChip(String label, int index, ColorScheme colorScheme) {
    final isSelected = _selectedChip == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedChip = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer.withOpacity(0.8) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.transparent)
              : Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
