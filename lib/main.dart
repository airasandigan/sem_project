import 'package:flutter/material.dart';


void main() => runApp(const MyApp());


// ---------- Route names (one place to change them) ----------
class Routes {
  static const home = '/';
  static const login = '/login';
  static const app = '/app';
}


// ---------- App + shared theme ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FieldNote',
      debugShowCheckedModeBanner: false,
      // Consistent header/theme styling: set once, used by every page.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
        ),
      ),
      initialRoute: Routes.home,
      // Page transition: a smooth fade + slide instead of the default.
      onGenerateRoute: (settings) {
        final Widget page;
        switch (settings.name) {
          case Routes.login:
            page = const LoginPage();
            break;
          case Routes.app:
            page = const MainShell();
            break;
          default:
            page = const HomePage();
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
        );
      },
    );
  }
}


// ---------- 1. Home page (visible landing screen) ----------
class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home_rounded, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('This is the home page of the app.'),
            const SizedBox(height: 32),
            // Route button -> page transition to Login
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, Routes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}


// ---------- 2. Login page (placeholder, no real checking yet) ----------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();


  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            // Keeps the form a standard width on wide screens (e.g. Chrome).
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    // Placeholder: any input lets you in for now.
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, Routes.app),
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ---------- 3. Main shell with navigation menu ----------
class MainShell extends StatefulWidget {
  const MainShell({super.key});


  @override
  State<MainShell> createState() => _MainShellState();
}


class _MainShellState extends State<MainShell> {
  int _index = 0;


  final _titles = const ['Dashboard', 'Profile', 'Settings'];
  final _pages = const [
    PlaceholderPage(icon: Icons.dashboard, label: 'Dashboard'),
    PlaceholderPage(icon: Icons.person, label: 'Profile'),
    PlaceholderPage(icon: Icons.settings, label: 'Settings'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (_) => false,
            ),
          ),
        ],
      ),
      body: _pages[_index],
      // Navigation menu
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}


class PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String label;
  const PlaceholderPage({super.key, required this.icon, required this.label});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.teal),
          const SizedBox(height: 12),
          Text('$label page', style: const TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}
//----
