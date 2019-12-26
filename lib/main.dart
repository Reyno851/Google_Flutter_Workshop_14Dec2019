import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insta Flutter',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: RandomImages(),
    );
  }
}

class RandomImagesState extends State<RandomImages> {
  bool _visible = true;
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (String url) {
              return ListTile(
                title: Image.network(url, height: 250),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Images'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Insta Flutter'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: Center(
          child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: _buildImages()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _visible = !_visible;
            });
          },
          child: Icon(Icons.flip),
        ));
  }

  final Set<String> _saved = Set<String>();
  final List<String> _urls = <String>[];

  Widget _buildImages() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final int index = i ~/ 2;

          if (index >= _urls.length) {
            _urls.addAll(List.generate(
                10,
                (number) =>
                    'https://picsum.photos/seed/${_urls.length + number + 1}/250/250'));
          }
          return _buildRow(_urls[index]);
        });
  }

  Widget _buildRow(String url) {
    final bool alreadySaved = _saved.contains(url);
    return ListTile(
      title: Image.network(url, height: 250),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(url);
          } else {
            _saved.add(url);
          }
        });
      },
    );
  }
}

class RandomImages extends StatefulWidget {
  @override
  RandomImagesState createState() => RandomImagesState();
}
