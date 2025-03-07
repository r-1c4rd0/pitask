import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PiNetworkAuth {
  // Configurações do Pi Network
  static const String piNetworkSandboxUrl = 'https://sandbox.minepi.com/';
  static const String piNetworkMainUrl = 'https://app-backend.minepi.com/';
  static const String appClientId = 'SEU_CLIENT_ID'; // Substitua pelo seu Client ID
  static const String redirectUri = 'SEU_REDIRECT_URI'; // URL de callback registrada

  // Token storage
  static Future<void> saveToken(String token, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pi_access_token', token);
    await prefs.setString('pi_user_id', uid);
  }

  static Future<Map<String, String?>> getStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('pi_access_token'),
      'uid': prefs.getString('pi_user_id'),
    };
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pi_access_token');
    await prefs.remove('pi_user_id');
  }
}

class PiNetworkLoginScreen extends StatefulWidget {
  final Function(String, String) onLoginSuccess;

  const PiNetworkLoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _PiNetworkLoginScreenState createState() => _PiNetworkLoginScreenState();
}

class _PiNetworkLoginScreenState extends State<PiNetworkLoginScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkExistingAuth();
  }

  Future<void> _checkExistingAuth() async {
    final authData = await PiNetworkAuth.getStoredAuth();
    if (authData['token'] != null && authData['uid'] != null) {
      // Verificar se o token ainda é válido com uma chamada à API Pi
      bool isValid = await _verifyToken(authData['token']!);
      if (isValid) {
        widget.onLoginSuccess(authData['token']!, authData['uid']!);
      }
    }
  }

  Future<bool> _verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${PiNetworkAuth.piNetworkSandboxUrl}api/v2/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login com Pi Network'),
        backgroundColor: const Color(0xFF7461FC), // Cor Pi Network
      ),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(
              backgroundColor: Color(0xFFD8D2FC),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7461FC)),
            ),
          /*Expanded(
            child: WebView(
              initialUrl: _buildPiAuthUrl(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _controller = controller;
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
                _handleRedirect(url);
              },
            ),
          ),*/
        ],
      ),
    );
  }

  String _buildPiAuthUrl() {
    return '${PiNetworkAuth.piNetworkSandboxUrl}oauth/authorize'
        '?client_id=${PiNetworkAuth.appClientId}'
        '&redirect_uri=${Uri.encodeComponent(PiNetworkAuth.redirectUri)}'
        '&response_type=code'
        '&scope=payments,username,wallet_address';
  }

  void _handleRedirect(String url) {
    if (url.startsWith(PiNetworkAuth.redirectUri)) {
      // Extrair o código de autorização
      Uri uri = Uri.parse(url);
      String? authCode = uri.queryParameters['code'];

      if (authCode != null) {
        _exchangeCodeForToken(authCode);
      }
    }
  }

  Future<void> _exchangeCodeForToken(String authCode) async {
    try {
      final response = await http.post(
        Uri.parse('${PiNetworkAuth.piNetworkSandboxUrl}oauth/token'),
        body: {
          'grant_type': 'authorization_code',
          'code': authCode,
          'client_id': PiNetworkAuth.appClientId,
          'redirect_uri': PiNetworkAuth.redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String accessToken = data['access_token'];

        // Obter informações do usuário
        final userResponse = await http.get(
          Uri.parse('${PiNetworkAuth.piNetworkSandboxUrl}api/v2/me'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);
          String uid = userData['uid'];

          // Salvar dados de autenticação
          await PiNetworkAuth.saveToken(accessToken, uid);

          // Callback de sucesso
          widget.onLoginSuccess(accessToken, uid);
        }
      }
    } catch (e) {
      print('Erro ao trocar código por token: $e');
    }
  }
}

// Exemplo de uso na página principal
class PiTaskApp extends StatefulWidget {
  @override
  _PiTaskAppState createState() => _PiTaskAppState();
}

class _PiTaskAppState extends State<PiTaskApp> {
  bool _isAuthenticated = false;
  String? _userId;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = await PiNetworkAuth.getStoredAuth();
    if (auth['token'] != null && auth['uid'] != null) {
      setState(() {
        _isAuthenticated = true;
        _accessToken = auth['token'];
        _userId = auth['uid'];
      });
    }
  }

  void _handleLoginSuccess(String token, String uid) {
    setState(() {
      _isAuthenticated = true;
      _accessToken = token;
      _userId = uid;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(userId: uid, token: token)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiTask',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isAuthenticated
          ? HomePage(userId: _userId!, token: _accessToken!)
          : PiNetworkLoginScreen(onLoginSuccess: _handleLoginSuccess),
    );
  }
}

// Página inicial após login
class HomePage extends StatelessWidget {
  final String userId;
  final String token;

  const HomePage({Key? key, required this.userId, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PiTask - Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await PiNetworkAuth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PiNetworkLoginScreen(
                    onLoginSuccess: (token, uid) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(userId: uid, token: token),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo ao PiTask!', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text('Usuário ID: $userId', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.work),
              label: const Text('Explorar Tarefas'),
              onPressed: () {
                // Navegação para a tela de tarefas
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_task),
              label: const Text('Criar Nova Tarefa'),
              onPressed: () {
                // Navegação para criação de tarefas
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}