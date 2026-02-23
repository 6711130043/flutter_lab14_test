import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ch1_unit_test_screen.dart';
import 'ch2_widget_test_screen.dart';
import 'ch3_integration_test_screen.dart';
import 'ch4_mocking_screen.dart';
import 'ch5_ci_cd_screen.dart';
import 'auth/auth_screen.dart';
import 'auth/profile_screen.dart';
import '../providers/auth_provider.dart';

class Chapter {
  final String number;
  final String title;
  final String thaiTitle;
  final IconData icon;
  final String description;
  final Widget Function() screenBuilder;

  Chapter({
    required this.number,
    required this.title,
    required this.thaiTitle,
    required this.icon,
    required this.description,
    required this.screenBuilder,
  });
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapters = [
      Chapter(
        number: '1',
        title: 'Unit Tests & Basics',
        thaiTitle: 'บทที่ 1: Unit Test พื้นฐาน',
        icon: Icons.check_circle,
        description: 'เรียนรู้การเขียน Unit Test ด้วยตัวอย่างจริง',
        screenBuilder: () => const Ch1UnitTestScreen(),
      ),
      Chapter(
        number: '2',
        title: 'Widget Testing',
        thaiTitle: 'บทที่ 2: Widget Test',
        icon: Icons.widgets,
        description: 'ทดสอบ Widget UI ด้วยการจำลองการกระทำของผู้ใช้',
        screenBuilder: () => const Ch2WidgetTestScreen(),
      ),
      Chapter(
        number: '3',
        title: 'Integration Testing',
        thaiTitle: 'บทที่ 3: Integration Test',
        icon: Icons.integration_instructions,
        description: 'ทดสอบการทำงานของแอปทั้งหมดแบบรวมกัน',
        screenBuilder: () => const Ch3IntegrationTestScreen(),
      ),
      Chapter(
        number: '4',
        title: 'Mocking & Faking',
        thaiTitle: 'บทที่ 4: Mocking และ Faking',
        icon: Icons.theaters,
        description: 'ทดสอบด้วยการจำลอง API และ Dependencies',
        screenBuilder: () => const Ch4MockingScreen(),
      ),
      Chapter(
        number: '5',
        title: 'CI/CD & Coverage',
        thaiTitle: 'บทที่ 5: CI/CD และ Coverage',
        icon: Icons.rocket_launch,
        description: 'ทำให้การทดสอบเป็นอัตโนมัติและตรวจสอบความครอบคลุม',
        screenBuilder: () => const Ch5CiCdScreen(),
      ),
    ];

    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    final currentUser = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Testing Demo'),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              tooltip: 'โปรไฟล์ของฉัน',
            )
          else
            IconButton(
              icon: const Icon(Icons.login_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              tooltip: 'เข้าสู่ระบบ',
            ),
        ],
      ),
      body: Column(
        children: [
          // Membership Section
          if (!isLoggedIn)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.9),
                    Colors.green.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_add_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'เข้าร่วมสมาชิก',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'สมัครสมาชิกเพื่อเข้าใช้งานฟีเจอร์เพิ่มเติม',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(
                                  initialMode: AuthMode.register,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('สมัครสมาชิก'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.9),
                    Colors.green.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        currentUser?.displayName.isNotEmpty == true
                            ? currentUser!.displayName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'สวัสดี!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentUser?.displayName ?? 'ผู้ใช้',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Chapters List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ChapterCard(
                      chapter: chapter,
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => chapter.screenBuilder(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }
}

class ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.chapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        chapter.number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.thaiTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chapter.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    chapter.icon,
                    size: 32,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                chapter.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
    );
  }
}
