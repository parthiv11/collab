import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../features/auth/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const ExploreTab(),
    const MessagesTab(),
    const NotificationsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final userType = authProvider.selectedUserType;

    String greeting = 'Hello';
    if (user != null) {
      greeting = 'Hello, ${user.name.split(' ')[0]}';
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getUserTypeLabel(userType),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await authProvider.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(context, '0', 'Projects'),
                    _buildDivider(),
                    _buildStat(context, '0', 'Connections'),
                    _buildDivider(),
                    _buildStat(context, '0', 'Pending'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recommended Section
            Text(
              'Recommended for you',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildRecommendationCard(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserTypeLabel(UserType type) {
    switch (type) {
      case UserType.influencer:
        return 'Content Creator';
      case UserType.brand:
        return 'Brand Account';
      case UserType.business:
        return 'Business Profile';
      default:
        return '';
    }
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }

  Widget _buildRecommendationCard(BuildContext context, int index) {
    // Mock data
    final List<Map<String, dynamic>> recommendations = [
      {
        'name': 'Jane Cooper',
        'type': 'Influencer',
        'category': 'Fashion & Lifestyle',
        'image': 'https://randomuser.me/api/portraits/women/44.jpg',
      },
      {
        'name': 'Nike',
        'type': 'Brand',
        'category': 'Sports & Fitness',
        'image': 'https://logo.clearbit.com/nike.com',
      },
      {
        'name': 'Coffee Shop Co.',
        'type': 'Business',
        'category': 'Food & Beverage',
        'image': 'https://logo.clearbit.com/starbucks.com',
      },
    ];

    final recommendation = recommendations[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(recommendation['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation['name'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recommendation['type'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    recommendation['category'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Connect Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(40, 36),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder Tabs
class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Explore Tab - Coming Soon'));
  }
}

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Messages Tab - Coming Soon'));
  }
}

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notifications Tab - Coming Soon'));
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
          child: const Text('Login'),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Picture
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                image:
                    user.profileImage != null
                        ? DecorationImage(
                          image: NetworkImage(user.profileImage!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  user.profileImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
            ),

            const SizedBox(height: 16),

            // Name
            Text(user.name, style: Theme.of(context).textTheme.headlineMedium),

            const SizedBox(height: 4),

            // User Type
            Text(
              _getUserTypeText(user.userType),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 32),

            // Profile options
            _buildProfileOption(context, 'Edit Profile', Icons.edit, () {}),

            _buildProfileOption(
              context,
              'My Projects',
              Icons.work_outline,
              () {},
            ),

            _buildProfileOption(
              context,
              'My Connections',
              Icons.people_outline,
              () {},
            ),

            _buildProfileOption(
              context,
              'Settings',
              Icons.settings_outlined,
              () {},
            ),

            _buildProfileOption(
              context,
              'Help & Support',
              Icons.help_outline,
              () {},
            ),

            const Spacer(),

            // Logout button
            OutlinedButton.icon(
              onPressed: () async {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserTypeText(UserType type) {
    switch (type) {
      case UserType.influencer:
        return 'Influencer';
      case UserType.brand:
        return 'Brand';
      case UserType.business:
        return 'Business';
      default:
        return '';
    }
  }

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 24),
            const SizedBox(width: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
