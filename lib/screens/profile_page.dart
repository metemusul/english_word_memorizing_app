import 'package:flutter/material.dart';
import '../main.dart';
import 'package:english_word_app/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeMode _selectedTheme = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userName = 'Kullanıcı';
    final userLevel = 7;
    final userScore = 1240;
    final badges = _badgeList;
    final userBadges = {0, 1, 2, 3, 4, 5, 7, 10, 12, 15}; // Dummy: kazanılan rozetler

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        // Ayarlar sayfasına yönlendirme
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Kullanıcı Bilgileri Kartı
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: theme.colorScheme.secondary,
                          child: Text(
                            userName[0],
                            style: TextStyle(
                              fontSize: 40,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildInfoChip(
                              icon: Icons.star,
                              label: 'Seviye $userLevel',
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 16),
                            _buildInfoChip(
                              icon: Icons.score,
                              label: '$userScore Puan',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tema Seçici ve Çıkış Yapma Butonu
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.palette),
                        title: const Text('Tema'),
                        subtitle: const Text('Uygulama temasını değiştir'),
                        trailing: DropdownButton<ThemeMode>(
                          value: _selectedTheme,
                          onChanged: (ThemeMode? newThemeMode) {
                            if (newThemeMode != null) {
                              setState(() {
                                _selectedTheme = newThemeMode;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text('Sistem'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text('Açık'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text('Koyu'),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Çıkış Yap'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // İstatistikler
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bar_chart, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'İstatistikler',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            _StatItem(
                              label: 'Oynanan Oyun',
                              value: '42',
                              icon: Icons.games,
                            ),
                            _StatItem(
                              label: 'Doğru Çeviri',
                              value: '31',
                              icon: Icons.check_circle,
                            ),
                            _StatItem(
                              label: 'Hikaye',
                              value: '15',
                              icon: Icons.auto_stories,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Rozetler
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.workspace_premium, color: Colors.amber.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Rozetler & Unvanlar',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: badges.length,
                          itemBuilder: (context, i) {
                            final badge = badges[i];
                            final earned = userBadges.contains(i);
                            return _BadgeCard(
                              icon: badge.icon,
                              name: badge.name,
                              description: badge.description,
                              earned: earned,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final bool earned;
  const _BadgeCard({
    required this.icon,
    required this.name,
    required this.description,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Tooltip(
      message: description,
      child: Opacity(
        opacity: earned ? 1 : 0.4,
        child: Card(
          color: isDark
              ? (earned ? Colors.grey[900] : Colors.grey[800])
              : (earned ? Colors.amber.shade50 : Colors.grey.shade200),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: earned ? 4 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: earned ? Colors.amber.shade700 : (isDark ? Colors.white70 : Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class BadgeData {
  final IconData icon;
  final String name;
  final String description;
  const BadgeData({required this.icon, required this.name, required this.description});
}

const List<BadgeData> _badgeList = [
  BadgeData(icon: Icons.translate, name: 'Çeviri Ustası', description: '10 çeviri tamamla'),
  BadgeData(icon: Icons.auto_stories, name: 'Hikaye Yazarı', description: '5 hikaye tamamla'),
  BadgeData(icon: Icons.flash_on, name: 'Hızlı Çözücü', description: '30 sn altında oyun bitir'),
  BadgeData(icon: Icons.calendar_today, name: 'Günlük Görevci', description: 'Günlük görevi tamamla'),
  BadgeData(icon: Icons.star, name: '7 Günlük Seribaşı', description: '7 gün üst üste oyna'),
  BadgeData(icon: Icons.search, name: 'Kelime Avcısı', description: '100 yeni kelime öğren'),
  BadgeData(icon: Icons.emoji_events, name: 'Quiz Şampiyonu', description: '10 quiz kazan'),
  BadgeData(icon: Icons.menu_book, name: 'Paragraf Ustası', description: '10 paragraf çevirisi yap'),
  BadgeData(icon: Icons.touch_app, name: 'Sürükle-Bırak Ustası', description: '20 cümle kur'),
  BadgeData(icon: Icons.bookmark, name: '100 Kelime Ezberi', description: '100 kelime ezberle'),
  BadgeData(icon: Icons.book, name: '500 Kelime Ezberi', description: '500 kelime ezberle'),
  BadgeData(icon: Icons.library_books, name: '1000 Kelime Ezberi', description: '1000 kelime ezberle'),
  BadgeData(icon: Icons.edit, name: 'İlk Hikaye', description: 'İlk hikayeni yaz'),
  BadgeData(icon: Icons.g_translate, name: 'İlk Çeviri', description: 'İlk çevirini yap'),
  BadgeData(icon: Icons.done_all, name: '10 Hikaye Tamamla', description: '10 hikaye tamamla'),
  BadgeData(icon: Icons.done, name: '10 Çeviri Tamamla', description: '10 çeviri tamamla'),
  BadgeData(icon: Icons.verified, name: '5 Rozet Kazan', description: '5 rozet kazan'),
  BadgeData(icon: Icons.verified_user, name: '10 Rozet Kazan', description: '10 rozet kazan'),
  BadgeData(icon: Icons.nightlight_round, name: 'Gece Yarısı Öğrencisi', description: 'Gece 00:00-03:00 arası oyna'),
  BadgeData(icon: Icons.share, name: 'Paylaşımcı', description: 'Kelime listesi paylaş'),
  BadgeData(icon: Icons.group, name: 'Arkadaş Canlısı', description: 'Arkadaş ekle'),
  BadgeData(icon: Icons.leaderboard, name: 'Günlük Skor Rekoru', description: 'Günlük skor rekoru kır'),
  BadgeData(icon: Icons.bug_report, name: 'Hata Avcısı', description: 'Hatasız 5 oyun bitir'),
  BadgeData(icon: Icons.timer, name: 'Süper Hızlı', description: '30 sn altında oyun bitir'),
  BadgeData(icon: Icons.bar_chart, name: 'İstatistik Ustası', description: 'İstatistik ekranını aç'),
]; 