// Importa os pacotes essenciais do Flutter e do Firebase.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importe suas configurações do Firebase geradas pelo FlutterFire CLI.
import 'firebase_options.dart';

// Ponto de entrada principal da aplicação.
void main() async {
  // Garante que os widgets do Flutter sejam inicializados antes de qualquer outra coisa.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase no seu projeto usando as configurações da plataforma atual.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Roda o aplicativo principal.
  runApp(const MednetApp());
}

// Widget raiz da sua aplicação.
class MednetApp extends StatelessWidget {
  const MednetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mednet ERP',
      // Define o tema visual do aplicativo.
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define uma estética moderna com Material 3.
        useMaterial3: true,
        // Adapta as cores do tema com base em um azul principal.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      // O 'home' será decidido pela Lógica de Autenticação.
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Este widget verifica o estado de autenticação do usuário e decide qual tela mostrar.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder ouve as mudanças no estado de autenticação do Firebase.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto aguarda a conexão, mostra um indicador de carregamento.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se o snapshot tem dados (usuário não é nulo), o usuário está logado.
        if (snapshot.hasData) {
          // Direciona para a tela principal do sistema (Dashboard).
          return const HomeScreen();
        }

        // Se não há dados, o usuário não está logado.
        // Direciona para a tela de login.
        return const LoginScreen();
      },
    );
  }
}

// --- Telas de Exemplo (Placeholder) ---
// Você irá substituir estas telas pelos seus designs completos.

// Tela principal para usuários autenticados.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o usuário atual para exibir informações (ex: email).
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mednet Dashboard'),
        actions: [
          // Botão para fazer logout.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Bem-vindo ao Mednet!\nLogado como: ${user?.email ?? 'Usuário'}',
        ),
      ),
    );
  }
}

// Tela de login para usuários não autenticados.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acesso ao Mednet')),
      body: const Center(
        // Aqui você construirá seu formulário de login (email, senha, botões).
        child: Text('Tela de Login'),
      ),
    );
  }
}
