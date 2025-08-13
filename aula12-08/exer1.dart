import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaCoruja(),
    ),
  );
}

class PaginaCoruja extends StatelessWidget {
  const PaginaCoruja({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      appBar: AppBar(
        title: Text('Coruja-buraqueira'),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Coruja-buraqueira',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('A coruja-buraqueira é uma ave strigiforme da família Strigidae. Também conhecida pelos nomes de caburé, caburé-de-cupim, caburé-do-campo, coruja-barata, coruja-do-campo, coruja-mineira, corujinha-buraqueira, corujinha-do-buraco, corujinha-do-campo, guedé, urucuera, urucureia, urucuriá, coruja-cupinzeira (algumas cidades de Goiás) e capotinha. Com o nome científico cunicularia (“pequeno mineiro”), recebe esse nome por cavar buracos no solo. Vive cerca de 9 anos em habitat selvagem. Costuma viver em campos, pastos, restingas, desertos, planícies, praias e aeroportos.'),
       
            SizedBox(height: 20), 
            Image.network(
              'https://agron.com.br/wp-content/uploads/2025/05/Como-a-coruja-buraqueira-vive-em-grupo-2.webp',
              width: 300,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaginaRolinha()),
                );
              },
              child: const Text('Ver Rolinha-do-planalto'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaginaRolinha extends StatelessWidget {
  const PaginaRolinha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('Rolinha-do-planalto'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Rolinha-do-planalto',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Rolinha-d olho-azul ou rolinha-do-planalto é uma espécie de ave da ordem dos Columbiformes, pertencente à família Columbidae. Seu habitat natural são florestas subtropicais ou tropicais secas com planície de pastagem. É ameaçada pela destruição de seu ambiente originário.'),
            SizedBox(height: 20), 
            Image.network(
              'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQbSghtvnSBnrx7yDd0h0u89V4BIq-2UchQNb52uQ--ITyBoT0DmW7CFPEFjES2Fnm2HBxOdMvbrdqA_K2xl8s89ykLiQRpE274OeGz9R2ZvQ',
              width: 300,
            ),
            SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar para Coruja'),
            ),
          ],
        ),
      ),
    );
  }
}