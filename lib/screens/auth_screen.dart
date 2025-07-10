import 'package:flutter/material.dart';
import '../services/social_api_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SocialApiService _socialApi = SocialApiService();
  bool _isConnectingX = false;
  bool _isConnectingIG = false;
  String? _xStatus;
  String? _igStatus;

  Future<void> _connectX() async {
    setState(() {
      _isConnectingX = true;
    });

    try {
      String? token = await _socialApi.authenticateX(context);
      setState(() {
        _xStatus = token != null ? 'Connected ✓' : 'Connection failed';
        _isConnectingX = false;
      });
    } catch (e) {
      setState(() {
        _xStatus = 'Error: $e';
        _isConnectingX = false;
      });
    }
  }

  Future<void> _connectInstagram() async {
    setState(() {
      _isConnectingIG = true;
    });

    try {
      String? token = await _socialApi.authenticateInstagram(context);
      setState(() {
        _igStatus = token != null ? 'Connected ✓' : 'Connection failed';
        _isConnectingIG = false;
      });
    } catch (e) {
      setState(() {
        _igStatus = 'Error: $e';
        _isConnectingIG = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Social Media'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Connect Your Social Media',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'To analyze your echo chamber and get personalized quests, connect your social media accounts. Your data is processed locally and privately.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // X (Twitter) Connection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.close, size: 32), // X icon placeholder
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'X (Twitter)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Analyze your X timeline for echo chambers'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_xStatus != null) ...[
                      Text(
                        _xStatus!,
                        style: TextStyle(
                          color: _xStatus!.contains('✓') ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ElevatedButton(
                      onPressed: _isConnectingX ? null : _connectX,
                      child: _isConnectingX
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Connect X'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Instagram Connection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.camera_alt, size: 32, color: Colors.purple),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instagram',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Analyze your Instagram content preferences'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_igStatus != null) ...[
                      Text(
                        _igStatus!,
                        style: TextStyle(
                          color: _igStatus!.contains('✓') ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ElevatedButton(
                      onPressed: _isConnectingIG ? null : _connectInstagram,
                      child: _isConnectingIG
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Connect Instagram'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Privacy Notice
            Card(
              color: Colors.green[50],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.security, color: Colors.green),
                    SizedBox(height: 8),
                    Text(
                      'Privacy Protected',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your social media data is analyzed locally on your device. We never store or share your personal content.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Skip for now button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Skip for now'),
            ),
          ],
        ),
      ),
    );
  }
}
