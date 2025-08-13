import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFE0F7FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4CAF50),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFCA28),
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: PaginaPrincipal(),
    ),
  );
}

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre Mim'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFFB0BEC5),
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text('Vitor Neves', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('20 anos', style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaFilmes()),
                );
              },
              child: Text('Filmes'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaLivros()),
                );
              },
              child: Text('Livros'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaginaFilmes extends StatelessWidget {
  const PaginaFilmes({super.key});

  Widget _buildListItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      color: Color(0xFFFFCA28),
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Filmes Favoritos'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          _buildListItem('1. Eu sou a Lenda'),
          _buildListItem('2. Até o Último Homem'),
          _buildListItem('3. Exterminador do Futuro'),
          _buildListItem('4. Interestelar'),
          _buildListItem('5. bad Boys'),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a tela principal
              },
              child: const Text('Voltar'),
            ),
          ),
        ],
      ),
    );
  }
}


class PaginaLivros extends StatelessWidget {
  const PaginaLivros({super.key});

  Widget _buildListItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      color: Color(0xFFFFCA28), 
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Livros Favoritos'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          _buildListItem('1. Senhor dos Anéis'),
          _buildListItem('2. 1984'),
          _buildListItem('3. O Hobbit'),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ),
        ],
      ),
    );
  }
}