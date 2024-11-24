import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página inicial'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        children: const [
          HomePage(),
          SearchPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(pageController: _pageController),
    );
  }
}

class AppBottomNavigation extends StatefulWidget {
  final PageController pageController;

  const AppBottomNavigation({super.key, required this.pageController});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  int _selectedIndex = 0;
  bool isProfileEnabled = false;

  void _onItemTapped(int index) {
    if (index == 2 && !isProfileEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aba "Perfil" desabilitada'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    widget.pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          key: ValueKey('bottom_nav_home'),
          icon: Icon(Icons.home),
          label: 'Inicial',
        ),
        BottomNavigationBarItem(
          key: ValueKey('bottom_nav_search'),
          icon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          key: ValueKey('bottom_nav_profile'),
          icon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _showAlertDialog(context),
        child: const Text('Abrir Dialog'),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta'),
          content: const Text('Janela aberta'),
          actions: [
            TextButton(
              key: const ValueKey('button_close_dialog'),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController productController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: productController,
            decoration: const InputDecoration(
              labelText: 'Produto',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final productName = productController.text.trim();
              if (productName.isNotEmpty) {
                _showWelcomeMessage(context, productName);
              } else {
                _showErrorMessage(context);
              }
            },
            child: const Text('Pesquisar produto'),
          ),
        ],
      ),
    );
  }

  void _showWelcomeMessage(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesquisa realizada com o produto: $productName!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, digite um texto para pesquisar.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Página de perfil desabilitada'));
  }
}
