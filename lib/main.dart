import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Modern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<String> calculationHistory = [];

  void _addToHistory(String calculation) {
    setState(() {
      calculationHistory.add(calculation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CalculatorPage(onCalculation: _addToHistory),
      HistoryPage(history: calculationHistory),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SizedBox(
        width: 400,
        height: 800,
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final Function(String) onCalculation;

  const CalculatorPage({
    super.key,
    required this.onCalculation,
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _operation = "";
  double _num1 = 0;
  bool _newNumber = true;

  // Warna tema
  final Color primaryColor = const Color(0xFF1A73E8);
  final Color secondaryColor = const Color(0xFF5F6368);
  final Color backgroundColor = const Color(0xFFF1F3F4);

  Widget _buildButton(String text, {Color? backgroundColor, Color? textColor}) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? this.backgroundColor,
          foregroundColor: textColor ?? secondaryColor,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () => _onButtonPressed(text),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Center( // Tambahkan Center di sini
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Tambahkan ini
            children: [
              // Display area
              Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _operation.isEmpty ? "" : "$_num1 $_operation",
                      style: TextStyle(
                        fontSize: 30,
                        color: secondaryColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _output,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Keypad
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                  children: [
                    _buildButton('C',
                        backgroundColor: const Color(0xFFFFEBEE),
                        textColor: Colors.red),
                    _buildButton('⌫', textColor: primaryColor),
                    _buildButton('%', textColor: primaryColor),
                    _buildButton('÷', textColor: primaryColor),
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', textColor: primaryColor),
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', textColor: primaryColor),
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', textColor: primaryColor),
                    _buildButton('00'),
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=',
                        backgroundColor: primaryColor, textColor: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(String buttonText) {
    if (buttonText == "C") {
      setState(() {
        _output = "0";
        _operation = "";
        _num1 = 0;
        _newNumber = true;
      });
    } else if (buttonText == "⌫") {
      setState(() {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      });
    } else if (buttonText == "%") {
      if (_output != "Error") {
        try {
          double number = double.parse(_output);
          setState(() {
            _output = (number / 100).toString();
          });
        } catch (e) {
          setState(() {
            _output = "Error";
          });
        }
      }
    } else if (['+', '-', '×', '÷'].contains(buttonText)) {
      if (_output != "Error") {
        setState(() {
          _num1 = double.parse(_output);
          _operation = buttonText;
          _newNumber = true;
        });
      }
    } else if (buttonText == "=") {
      if (_operation.isNotEmpty && _output != "Error") {
        try {
          double num2 = double.parse(_output);
          double result;

          switch (_operation) {
            case '+':
              result = _num1 + num2;
              break;
            case '-':
              result = _num1 - num2;
              break;
            case '×':
              result = _num1 * num2;
              break;
            case '÷':
              if (num2 == 0) {
                throw Exception('Tidak bisa dibagi dengan nol');
              }
              result = _num1 / num2;
              break;
            default:
              return;
          }

          String formattedResult = result % 1 == 0
              ? result.toInt().toString()
              : result.toStringAsFixed(2);

          String calculation = "$_num1 $_operation $num2 = $formattedResult";
          widget.onCalculation(calculation);

          setState(() {
            _output = formattedResult;
            _operation = "";
            _newNumber = true;
          });
        } catch (e) {
          setState(() {
            _output = "Error";
            _newNumber = true;
          });
        }
      }
    } else {
      setState(() {
        if (_newNumber) {
          _output = buttonText;
          _newNumber = false;
        } else {
          if (buttonText == "." && _output.contains(".")) {
            // Mencegah multiple decimal points
            return;
          }
          if (buttonText == "00" && _output == "0") {
            // Mencegah leading zeros
            return;
          }
          _output = _output + buttonText;
        }
      });
    }
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> history;

  const HistoryPage({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: history.isEmpty
            ? Center( // Tambahkan Center di sini
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Tambahkan ini
                  children: [
                    Icon(
                      Icons.history_outlined,
                      size: 72,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada riwayat perhitungan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[history.length - 1 - index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[50],
        child: Center( // Membungkus seluruh konten dengan Center
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Memastikan elemen berada di tengah
              crossAxisAlignment: CrossAxisAlignment.center, // Memastikan elemen sejajar di tengah secara horizontal
              children: [
                // Header dengan gradient
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue[400]!,
                        Colors.blue[800]!,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Julian Maem',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Profile cards
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileCard(
                        icon: Icons.person_outline,
                        title: 'Username',
                        subtitle: '@julianjihan',
                        iconColor: Colors.blue,
                      ),
                      _buildProfileCard(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: 'julianjihan@gmail.com',
                        iconColor: Colors.green,
                      ),
                      _buildProfileCard(
                        icon: Icons.phone_outlined,
                        title: 'Nomor Telepon',
                        subtitle: '+62 123 4567 8900',
                        iconColor: Colors.orange,
                      ),
                      _buildProfileCard(
                        icon: Icons.location_on_outlined,
                        title: 'Lokasi',
                        subtitle: 'Pandak, DIY, Indonesia',
                        iconColor: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
