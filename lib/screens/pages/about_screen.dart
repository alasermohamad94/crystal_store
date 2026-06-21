import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppDrawer(),
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
        title: const Text('من نحن'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // لا يوجد بيانات للتحديث في هذه الصفحة
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              'مرحباً بك في Crystal Store',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              '''
تعريف التطبيق وطبيعة عمله :

نحن تطبيق إلكتروني متخصص في توفير خدمات تعبئة رصيد وحدات شبكتي MTN & Syriatel. نحرص على تقديم تجربة شراء سريعة وآمنة، مع توفير دعم فني متواصل على مدار الساعة لضمان تلبية احتياجات مستخدمينا والإجابة عن استفساراتهم، نلتزم بالأنظمة والقوانين المعمول بها

تتم عمليات الدفع وتسوية العمليات المالية عبر مكتبنا المعتمد، مع الالتزام الكامل بمعايير الشفافية وحماية بيانات العملاء، نعمل باستمرار على تطوير خدماتنا وتحسين تجربة المستخدم لضمان تقديم حلول رقمية آمنة وفعالة تلبي احتياجات العملاء في مجال الشحن الإلكتروني.
''',
          
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            _InfoCard(
              icon: Icons.speed,
              title: 'سرعة في التوصيل',
              description: 'نوصل طلباتك في أسرع وقت ممكن',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.security,
              title: 'آمن ومضمون',
              description: 'جميع المعاملات آمنة ومشفرة',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.support_agent,
              title: 'دعم فني 24/7',
              description: 'فريقنا جاهز لمساعدتك في أي وقت',
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

