// QUEUE THEORY CALCULATOR - FLUTTER APP
// Complete implementation with monetization ready

/*
═══════════════════════════════════════════════════════════════
SETUP INSTRUCTIONS - READ FIRST
═══════════════════════════════════════════════════════════════

1. CREATE NEW FLUTTER PROJECT:
   flutter create queue_calculator
   cd queue_calculator

2. UPDATE pubspec.yaml - ADD THESE DEPENDENCIES:
   dependencies:
     flutter:
       sdk: flutter
     in_app_purchase: ^3.1.11
     shared_preferences: ^2.2.2
     google_fonts: ^6.1.0
     fl_chart: ^0.65.0
     pdf: ^3.10.7
     path_provider: ^2.1.1

3. REPLACE lib/main.dart WITH THIS FILE

4. RUN: flutter pub get

5. FOR ANDROID (Google Play):
   - Update android/app/build.gradle (minSdkVersion 21)
   - Add billing permission in AndroidManifest.xml

6. TEST: flutter run

ESTIMATED TIME: 2-4 weeks to fully polish and launch
═══════════════════════════════════════════════════════════════
*/

import 'package:flutter/material.dart';
import 'dart:math';
// import 'package:in_app_purchase/in_app_purchase.dart'; // Uncomment for production
// import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const QueueCalculatorApp());
}

class QueueCalculatorApp extends StatelessWidget {
  const QueueCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Queue Theory Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2d5016),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2d5016),
          primary: const Color(0xFF2d5016),
          secondary: const Color(0xFFe8b86d),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F6F0),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// Queue Theory Calculation Functions
class QueueCalculations {
  static double factorial(int n) {
    if (n <= 1) return 1.0;
    double result = 1.0;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  static int calculateMinServers(double arrivalRate, double serviceRate) {
    return (arrivalRate / serviceRate).ceil();
  }

  static double calculateTrafficIntensity(
      double arrivalRate, double serviceRate, int numServers) {
    return arrivalRate / (numServers * serviceRate);
  }

  static double calculateP0(
      double arrivalRate, double serviceRate, int numServers) {
    final rho = arrivalRate / serviceRate;
    final trafficIntensity =
        calculateTrafficIntensity(arrivalRate, serviceRate, numServers);

    double sum = 0;
    for (int n = 0; n < numServers; n++) {
      sum += pow(rho, n) / factorial(n);
    }

    final lastTerm = pow(rho, numServers) /
        (factorial(numServers) * (1 - trafficIntensity));
    return 1 / (sum + lastTerm);
  }

  static double calculateErlangC(
      double arrivalRate, double serviceRate, int numServers) {
    final rho = arrivalRate / serviceRate;
    final trafficIntensity =
        calculateTrafficIntensity(arrivalRate, serviceRate, numServers);
    final p0 = calculateP0(arrivalRate, serviceRate, numServers);

    return (pow(rho, numServers) * p0) /
        (factorial(numServers) * (1 - trafficIntensity));
  }

  static double calculateWaitTime(
      double arrivalRate, double serviceRate, int numServers) {
    final erlangC = calculateErlangC(arrivalRate, serviceRate, numServers);
    final trafficIntensity =
        calculateTrafficIntensity(arrivalRate, serviceRate, numServers);

    final waitTimeHours =
        erlangC / (numServers * serviceRate * (1 - trafficIntensity));
    return waitTimeHours * 60; // Convert to minutes
  }

  static Map<String, dynamic> analyzeStaffing(
      double arrivalRate, double serviceRate, double targetWaitMinutes) {
    final minServers = calculateMinServers(arrivalRate, serviceRate);
    final scenarios = <Map<String, dynamic>>[];
    Map<String, dynamic>? optimal;

    for (int numServers = minServers; numServers <= minServers + 10; numServers++) {
      final trafficIntensity =
          calculateTrafficIntensity(arrivalRate, serviceRate, numServers);

      if (trafficIntensity >= 1) continue;

      try {
        final waitTime = calculateWaitTime(arrivalRate, serviceRate, numServers);
        final erlangC = calculateErlangC(arrivalRate, serviceRate, numServers);

        final scenario = {
          'numServers': numServers,
          'waitTime': waitTime,
          'utilization': trafficIntensity * 100,
          'probWait': erlangC * 100,
          'meetsTarget': waitTime <= targetWaitMinutes,
        };

        scenarios.add(scenario);

        if (optimal == null && waitTime <= targetWaitMinutes) {
          optimal = scenario;
        }
      } catch (e) {
        continue;
      }
    }

    return {
      'optimal': optimal,
      'scenarios': scenarios,
      'minServers': minServers,
    };
  }
}

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _arrivalController = TextEditingController(text: '40');
  final _serviceController = TextEditingController(text: '20');
  final _targetController = TextEditingController(text: '5');

  Map<String, dynamic>? _results;
  bool _isCalculating = false;
  bool _isPremium = false; // In production, load from SharedPreferences
  int _calculationsToday = 0; // Track free tier usage

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    // In production, implement:
    // final prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _isPremium = prefs.getBool('isPremium') ?? false;
    //   _calculationsToday = prefs.getInt('calculationsToday') ?? 0;
    // });
  }

  void _calculate() {
    // Free tier limitation
    if (!_isPremium && _calculationsToday >= 3) {
      _showUpgradeDialog();
      return;
    }

    final arrival = double.tryParse(_arrivalController.text);
    final service = double.tryParse(_serviceController.text);
    final target = double.tryParse(_targetController.text);

    if (arrival == null || service == null || target == null ||
        arrival <= 0 || service <= 0 || target <= 0) {
      _showError('Please enter valid positive numbers for all fields.');
      return;
    }

    setState(() => _isCalculating = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      final results = QueueCalculations.analyzeStaffing(arrival, service, target);
      
      setState(() {
        _results = results;
        _isCalculating = false;
        if (!_isPremium) _calculationsToday++;
      });
    });
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text(
          'You\'ve reached your free limit of 3 calculations per day.\n\n'
          'Upgrade to Premium for:\n'
          '• Unlimited calculations\n'
          '• Save scenarios\n'
          '• Export to PDF\n'
          '• No ads\n\n'
          'Only \$3.99/month or \$39.99/year!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handlePurchase();
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  void _handlePurchase() {
    // In production, implement in-app purchase:
    // final InAppPurchase iap = InAppPurchase.instance;
    // Show purchase flow for 'premium_monthly' or 'premium_yearly'
    
    // For demo:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('In-app purchase would be initiated here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _loadExample(double arrival, double service, double target, String name) {
    setState(() {
      _arrivalController.text = arrival.toString();
      _serviceController.text = service.toString();
      _targetController.text = target.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name example loaded. Tap Calculate!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue Theory Calculator'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isPremium)
            TextButton.icon(
              onPressed: _handlePurchase,
              icon: const Icon(Icons.star, color: Colors.amber),
              label: const Text(
                'Premium',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '⏱️',
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Optimize Your Staffing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  if (!_isPremium)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Free: ${3 - _calculationsToday} calculations left today',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Input Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Business Data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _arrivalController,
                        label: 'Customer Arrival Rate',
                        hint: 'Customers per hour',
                        icon: Icons.people,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: _serviceController,
                        label: 'Service Rate',
                        hint: 'Customers one employee serves/hour',
                        icon: Icons.speed,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: _targetController,
                        label: 'Target Wait Time',
                        hint: 'Maximum acceptable wait (minutes)',
                        icon: Icons.timer,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isCalculating ? null : _calculate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _isCalculating
                                ? 'Calculating...'
                                : 'Calculate Optimal Staffing',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Examples
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Try These Examples',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildExampleTile(
                        emoji: '☕',
                        title: 'Coffee Shop',
                        description: '40 customers/hr • 20 served/hr • 5 min',
                        onTap: () => _loadExample(40, 20, 5, 'Coffee Shop'),
                      ),
                      _buildExampleTile(
                        emoji: '🏦',
                        title: 'Bank Branch',
                        description: '25 customers/hr • 12 served/hr • 5 min',
                        onTap: () => _loadExample(25, 12, 5, 'Bank Branch'),
                      ),
                      _buildExampleTile(
                        emoji: '📞',
                        title: 'Call Center',
                        description: '100 calls/hr • 12 calls/hr • 3 min',
                        onTap: () => _loadExample(100, 12, 3, 'Call Center'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Results
            if (_results != null && _results!['optimal'] != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ResultsCard(results: _results!),
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F6F0),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleTile({
    required String emoji,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F6F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
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
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

// Results Card Widget
class ResultsCard extends StatelessWidget {
  final Map<String, dynamic> results;

  const ResultsCard({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final optimal = results['optimal'] as Map<String, dynamic>;
    final scenarios = results['scenarios'] as List<Map<String, dynamic>>;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Your Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildMetric(
                  label: 'OPTIMAL STAFFING',
                  value: optimal['numServers'].toString(),
                  unit: 'employees',
                  color: const Color(0xFF2d5016),
                ),
                _buildMetric(
                  label: 'WAIT TIME',
                  value: optimal['waitTime'].toStringAsFixed(2),
                  unit: 'minutes',
                  color: const Color(0xFF4a7c2a),
                ),
                _buildMetric(
                  label: 'UTILIZATION',
                  value: optimal['utilization'].toStringAsFixed(1),
                  unit: '%',
                  color: const Color(0xFFe8b86d),
                ),
                _buildMetric(
                  label: 'CHANCE OF WAIT',
                  value: optimal['probWait'].toStringAsFixed(1),
                  unit: '%',
                  color: const Color(0xFFd4a574),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Recommendation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F6F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFe8b86d), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 Recommendation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'With ${optimal['numServers']} employees, you\'ll maintain '
                    'an average wait time of ${optimal['waitTime'].toStringAsFixed(2)} minutes. '
                    '${_getUtilizationMessage(optimal['utilization'])}',
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Scenarios
            const Text(
              'Staffing Scenarios',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            ...scenarios.take(5).map((scenario) {
              final isOptimal = scenario['numServers'] == optimal['numServers'];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOptimal
                      ? const Color(0xFF2d5016).withOpacity(0.1)
                      : const Color(0xFFF8F6F0),
                  borderRadius: BorderRadius.circular(8),
                  border: isOptimal
                      ? Border.all(color: const Color(0xFF2d5016), width: 2)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${scenario['numServers']} Staff',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${scenario['waitTime'].toStringAsFixed(2)} min • '
                            '${scenario['utilization'].toStringAsFixed(1)}% busy',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: scenario['meetsTarget']
                            ? const Color(0xFF4a7c2a)
                            : const Color(0xFFc44536),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        scenario['meetsTarget'] ? '✓ Target' : '✗ Slow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getUtilizationMessage(double utilization) {
    if (utilization < 70) {
      return 'Your staff will have some idle time, good for quality.';
    } else if (utilization < 85) {
      return 'Your staff will be efficiently utilized.';
    } else {
      return 'Your staff will be very busy.';
    }
  }
}

/*
═══════════════════════════════════════════════════════════════
MONETIZATION IMPLEMENTATION
═══════════════════════════════════════════════════════════════

1. IN-APP PURCHASES (Google Play):
   
   Add to android/app/build.gradle:
   defaultConfig {
       ...
       minSdkVersion 21
   }
   
   Add to AndroidManifest.xml:
   <uses-permission android:name="com.android.vending.BILLING" />

2. CREATE PRODUCTS IN GOOGLE PLAY CONSOLE:
   
   Product IDs:
   - premium_monthly: $3.99/month
   - premium_yearly: $39.99/year
   
3. IMPLEMENT IN-APP PURCHASE:
   
   import 'package:in_app_purchase/in_app_purchase.dart';
   
   // Initialize
   final InAppPurchase _iap = InAppPurchase.instance;
   
   // Load products
   const Set<String> _kIds = {'premium_monthly', 'premium_yearly'};
   final ProductDetailsResponse response = 
       await _iap.queryProductDetails(_kIds);
   
   // Purchase
   final PurchaseParam purchaseParam = 
       PurchaseParam(productDetails: productDetails);
   _iap.buyNonConsumable(purchaseParam: purchaseParam);

4. FREE TIER LIMITATIONS:
   - 3 calculations per day (reset at midnight)
   - No PDF export
   - No scenario saving
   - Show upgrade prompts

5. PREMIUM FEATURES:
   - Unlimited calculations
   - PDF export
   - Save scenarios
   - Cost analysis
   - No ads
   - Priority support

═══════════════════════════════════════════════════════════════
LAUNCH CHECKLIST
═══════════════════════════════════════════════════════════════

□ Update app name and package ID
□ Create app icon (1024x1024)
□ Add privacy policy URL
□ Set up Google Play Console
□ Create store listing (description, screenshots)
□ Implement in-app purchases
□ Test on multiple devices
□ Create promotional graphics
□ Set pricing and countries
□ Submit for review

ESTIMATED TIMELINE:
- Development: 2-3 weeks
- Testing: 1 week
- Store setup: 3-5 days
- Review: 1-3 days
- TOTAL: 4-5 weeks to launch

═══════════════════════════════════════════════════════════════
*/
