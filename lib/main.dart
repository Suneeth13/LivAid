import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LiveAidApp());
}

/* -------------------- APP ROOT -------------------- */

class LiveAidApp extends StatelessWidget {
  const LiveAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveAid',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* -------------------- SPLASH -------------------- */

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// ✅ FIX: navigate AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserDetails();
    });
  }

  Future<void> _checkUserDetails() async {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/* -------------------- ONBOARDING -------------------- */

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String age = '';
  String gender = '';
  String phone = '';
  String? country;

  final List<String> _countries = ['IN', 'US', 'UK', 'AU', 'CN'];

  Future<void> _saveUserDetails() async {
    if (!_formKey.currentState!.validate() || country == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('age', age);
    await prefs.setString('gender', gender);
    await prefs.setString('phone', phone);
    await prefs.setString('country', country!);

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to LiveAid')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Enter Name' : null,
                onChanged: (v) => name = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter Age' : null,
                onChanged: (v) => age = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (v) => v!.isEmpty ? 'Enter Gender' : null,
                onChanged: (v) => gender = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Enter Phone' : null,
                onChanged: (v) => phone = v,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Country'),
                items: _countries
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => country = v),
                validator: (v) => v == null ? 'Select Country' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserDetails,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------- HOME -------------------- */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final services = const [
    {'name': 'Ambulance', 'icon': '🚑', 'service': 'ambulance'},
    {'name': 'Police', 'icon': '🚓', 'service': 'police'},
    {'name': 'Fire', 'icon': '🚒', 'service': 'fire'},
    {'name': 'Adult Emergency', 'icon': '🆘', 'service': 'adult'},
    {'name': 'Vehicle Breakdown', 'icon': '🚗', 'service': 'vehicle'},
    {'name': 'Disaster Help', 'icon': '🌪️', 'service': 'disaster'},
    {'name': 'Lost & Found', 'icon': '📦', 'service': 'lostfound'},
    {'name': 'Blood Bank Emergency', 'icon': '🏥', 'service': 'bloodbank'},
    {'name': 'Blackmail Emergency', 'icon': '🔒', 'service': 'blackmail'},
    {'name': 'TNSTC Bus Change', 'icon': '🚌', 'service': 'buschange'},
    {'name': 'Child Emergency', 'icon': '👶', 'service': 'child'},
    {'name': 'Dog Ambulance', 'icon': '🐕', 'service': 'dogambulance'},
    {'name': 'Eye Bank', 'icon': '👁️', 'service': 'eyebank'},
    {'name': 'Girl Emergency 1', 'icon': '👧', 'service': 'girlemergency1'},
    {'name': 'Girl Emergency 2', 'icon': '👧', 'service': 'girlemergency2'},
    {'name': 'Highway Help', 'icon': '🛣️', 'service': 'highway'},
    {'name': 'Hotel Complaints', 'icon': '🏨', 'service': 'hotel'},
    {'name': 'MRP WhatsApp', 'icon': '📱', 'service': 'mrp'},
    {'name': 'Fuel', 'icon': '⛽', 'service': 'fuel'},
    {'name': 'Small Roadside Problems', 'icon': '🚧', 'service': 'roadside'},
    {'name': 'Train Help', 'icon': '🚂', 'service': 'train'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveAid Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (_, i) {
          return ElevatedButton(
            onPressed: () => callEmergency(services[i]['service']!, context),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  services[i]['icon']!,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 10),
                Text(services[i]['name']!, textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* -------------------- CALL HANDLER -------------------- */

Future<void> callEmergency(String service, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final country = prefs.getString('country') ?? 'IN';

  const numbers = {
    "IN": {
      "ambulance": "108",
      "police": "100",
      "fire": "101",
      "adult": "1253",
      "bloodbank": "1910",
      "blackmail": "1930",
      "buschange": "18005991500",
      "child": "1098",
      "dogambulance": "9820122602",
      "eyebank": "1919",
      "girlemergency1": "181",
      "girlemergency2": "1091",
      "highway": "1033",
      "hotel": "9434042322",
      "mrp": "8800001915",
      "fuel": "18002090247",
      "roadside": "1093",
      "train": "9221193322",
    },
    "US": {"universal": "911"},
    "UK": {"universal": "999"},
    "AU": {"universal": "000"},
    "CN": {"police": "110", "ambulance": "120", "fire": "119"},
  };

  final map = numbers[country] ?? {};
  final number = map[service] ?? map['universal'] ?? '112';

  bool? result = await FlutterPhoneDirectCaller.callNumber(number);
  if (result == true) return;

  final uri = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Unable to make the call')));
  }
}
