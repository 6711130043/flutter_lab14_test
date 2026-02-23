import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Ch4MockingScreen extends StatefulWidget {
  const Ch4MockingScreen({super.key});

  @override
  State<Ch4MockingScreen> createState() => _Ch4MockingScreenState();
}

class _Ch4MockingScreenState extends State<Ch4MockingScreen> {
  bool showRealApi = true;
  bool isLoading = false;
  String? result;
  String? error;

  void _fetchRealAPI() async {
    setState(() {
      isLoading = true;
      result = null;
      error = null;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      isLoading = false;
      error = 'เครือข่ายเชื่อมต่อไม่ได้ (จำลองข้อผิดพลาด)';
    });
  }

  void _fetchMockAPI() async {
    setState(() {
      isLoading = true;
      result = null;
      error = null;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      isLoading = false;
      result = '''
User(
  id: 1,
  name: 'สมชาย ใจดี',
  email: 'somchai@example.com',
  isActive: true
)
      ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('บทที่ 4: Mocking และ Faking'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.green.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mocking คืออะไร?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mocking คือการจำลอง (Simulate) external dependencies เช่น API, Database เพื่อให้การทดสอบเร็วขึ้นและเชื่อถือได้',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: isMobile
                  ? Column(
                      children: [
                        _APIPanel(
                          title: 'Real API',
                          thaiTitle: 'API จริง',
                          description: 'เชื่อมต่อเซิร์ฟเวอร์จริง - อาจล้มเหลวได้',
                          isLoading: isLoading && showRealApi,
                          result: showRealApi ? result : null,
                          error: showRealApi ? error : null,
                          onFetch: () {
                            setState(() => showRealApi = true);
                            _fetchRealAPI();
                          },
                          isActive: showRealApi,
                          codeExample: '''final api = ApiService();
try {
  final user = await api.fetchUser(1);
  print(user.name);
} catch (e) {
  print('Error: \$e');
}''',
                        ),
                        const SizedBox(height: 16),
                        _APIPanel(
                          title: 'Mock API',
                          thaiTitle: 'Mock API',
                          description: 'ใช้ข้อมูลจำลอง - เร็วและเชื่อถือได้',
                          isLoading: isLoading && !showRealApi,
                          result: !showRealApi ? result : null,
                          error: !showRealApi ? error : null,
                          onFetch: () {
                            setState(() => showRealApi = false);
                            _fetchMockAPI();
                          },
                          isActive: !showRealApi,
                          codeExample: '''final mockClient = MockHttpClient();
final api = ApiService(
  httpClient: mockClient,
);
final user = await api.fetchUser(1);''',
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _APIPanel(
                            title: 'Real API',
                            thaiTitle: 'API จริง',
                            description: 'เชื่อมต่อเซิร์ฟเวอร์จริง - อาจล้มเหลวได้',
                            isLoading: isLoading && showRealApi,
                            result: showRealApi ? result : null,
                            error: showRealApi ? error : null,
                            onFetch: () {
                              setState(() => showRealApi = true);
                              _fetchRealAPI();
                            },
                            isActive: showRealApi,
                            codeExample: '''final api = ApiService();
try {
  final user = await api.fetchUser(1);
  print(user.name);
} catch (e) {
  print('Error: \$e');
}''',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _APIPanel(
                            title: 'Mock API',
                            thaiTitle: 'Mock API',
                            description: 'ใช้ข้อมูลจำลอง - เร็วและเชื่อถือได้',
                            isLoading: isLoading && !showRealApi,
                            result: !showRealApi ? result : null,
                            error: !showRealApi ? error : null,
                            onFetch: () {
                              setState(() => showRealApi = false);
                              _fetchMockAPI();
                            },
                            isActive: !showRealApi,
                            codeExample: '''final mockClient = MockHttpClient();
final api = ApiService(
  httpClient: mockClient,
);
final user = await api.fetchUser(1);''',
                          ),
                        ),
                      ],
                    ),
            ),

            // Benefits Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข้อดีของ Mocking:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _BenefitItem(
                      icon: Icons.speed,
                      title: 'เร็ว',
                      description: 'ไม่ต้องรอการตอบสนองจากเซิร์ฟเวอร์',
                    ),
                    const SizedBox(height: 8),
                    _BenefitItem(
                      icon: Icons.verified,
                      title: 'เชื่อถือได้',
                      description: 'ผลลัพธ์คงที่ ไม่ขึ้นอยู่กับสถานะเครือข่าย',
                    ),
                    const SizedBox(height: 8),
                    _BenefitItem(
                      icon: Icons.edit,
                      title: 'ควบคุมได้',
                      description: 'สามารถจำลองสถานการณ์ต่างๆ เช่น Error',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _APIPanel extends StatelessWidget {
  final String title;
  final String thaiTitle;
  final String description;
  final bool isLoading;
  final String? result;
  final String? error;
  final VoidCallback onFetch;
  final bool isActive;
  final String codeExample;

  const _APIPanel({
    required this.title,
    required this.thaiTitle,
    required this.description,
    required this.isLoading,
    required this.result,
    required this.error,
    required this.onFetch,
    required this.isActive,
    required this.codeExample,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thaiTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: isLoading ? null : onFetch,
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_download),
            label: Text(isLoading ? 'Loading...' : 'ดึงข้อมูล'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 36),
            ),
          ),
          const SizedBox(height: 12),
          if (result != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                result!,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Courier',
                  color: Colors.green[700],
                ),
              ),
            ),
          if (error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                error!,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Courier',
                  color: Colors.red[700],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                codeExample,
                style: TextStyle(
                  fontSize: 9,
                  fontFamily: 'Courier',
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
