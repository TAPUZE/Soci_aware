import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialApiService {
  final storage = const FlutterSecureStorage();
  static const String xClientId = 'YOUR_X_CLIENT_ID';  // Replace with your X client ID
  static const String igAppId = 'YOUR_IG_APP_ID';      // Replace with your Instagram app ID
  static const String redirectUri = 'perspective://auth';

  // X OAuth 2.0 PKCE Flow
  Future<String?> authenticateX(BuildContext context) async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          if (request.url.startsWith(redirectUri)) {
            // Extract authorization code from URL
            Uri uri = Uri.parse(request.url);
            String? code = uri.queryParameters['code'];
            if (code != null) {
              _exchangeXCodeForToken(code);
            }
            Navigator.of(context).pop();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(
        'https://twitter.com/i/oauth2/authorize?'
        'response_type=code&'
        'client_id=$xClientId&'
        'redirect_uri=$redirectUri&'
        'scope=tweet.read%20users.read%20offline.access&'
        'state=perspective_quest&'
        'code_challenge=challenge&'  // In real implementation, generate proper PKCE
        'code_challenge_method=S256'
      ));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Connect X Account'),
        content: SizedBox(
          height: 500,
          width: 400,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
    
    return await storage.read(key: 'x_access_token');
  }

  Future<void> _exchangeXCodeForToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.twitter.com/2/oauth2/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': xClientId,
          'code_verifier': 'challenge', // In real implementation, use proper verifier
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await storage.write(key: 'x_access_token', value: data['access_token']);
      }
    } catch (e) {
      print('Token exchange failed: $e');
    }
  }

  Future<List<String>> fetchXPosts(String accessToken, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.twitter.com/2/users/$userId/tweets?max_results=100'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> tweets = data['data'] ?? [];
        return tweets.map((tweet) => tweet['text'] as String).toList();
      }
    } catch (e) {
      print('Failed to fetch X posts: $e');
    }
    return [];
  }

  // Instagram Graph API authentication
  Future<String?> authenticateInstagram(BuildContext context) async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          if (request.url.startsWith(redirectUri)) {
            Uri uri = Uri.parse(request.url);
            String? code = uri.queryParameters['code'];
            if (code != null) {
              _exchangeIgCodeForToken(code);
            }
            Navigator.of(context).pop();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(
        'https://api.instagram.com/oauth/authorize?'
        'client_id=$igAppId&'
        'redirect_uri=$redirectUri&'
        'scope=user_profile,user_media&'
        'response_type=code'
      ));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Connect Instagram Account'),
        content: SizedBox(
          height: 500,
          width: 400,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
    
    return await storage.read(key: 'ig_access_token');
  }

  Future<void> _exchangeIgCodeForToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.instagram.com/oauth/access_token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': igAppId,
          'client_secret': 'YOUR_IG_CLIENT_SECRET', // Replace with your secret
          'grant_type': 'authorization_code',
          'redirect_uri': redirectUri,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await storage.write(key: 'ig_access_token', value: data['access_token']);
        await storage.write(key: 'ig_user_id', value: data['user_id'].toString());
      }
    } catch (e) {
      print('Instagram token exchange failed: $e');
    }
  }

  Future<List<String>> fetchInstagramPosts(String accessToken, String igUserId) async {
    try {
      final response = await http.get(
        Uri.parse('https://graph.instagram.com/$igUserId/media?fields=caption&access_token=$accessToken'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> media = data['data'] ?? [];
        return media
            .where((item) => item['caption'] != null)
            .map((item) => item['caption'] as String)
            .toList();
      }
    } catch (e) {
      print('Failed to fetch Instagram posts: $e');
    }
    return [];
  }

  // Mock data for development/testing
  Future<List<String>> getMockPosts() async {
    return [
      'Just read an amazing article about conservative economic policies and their impact on small businesses.',
      'Climate change is the biggest threat facing our generation. We need immediate action!',
      'Traditional family values are the foundation of a strong society.',
      'Universal healthcare would solve so many problems in our country.',
      'The free market always finds the most efficient solutions.',
      'We need more diversity and inclusion in our workplaces.',
      'Border security is a national priority that cannot be ignored.',
      'Social justice movements are essential for progress.',
      'Limited government intervention leads to better outcomes.',
      'Education funding should be our top priority.',
    ];
  }
}
