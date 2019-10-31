import 'dart:convert';
import 'package:http/http.dart' as http;

// Streams
import 'dart:async';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {
  String _apikey = 'f4d30dfea84b32afbba315fe5d1ed849';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;

  bool _cargando = false;

  // Streams, lo que transmitira es un listado de  peliculas
  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      new StreamController<List<Pelicula>>.broadcast();

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    // Construir  URL para realizar peticion http
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    // print('Cargando siguientes...');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;

    return resp;
  }

  Future<List<Actor>> getActores(String peliculaId) async {
    final url = Uri.https(_url, '3/movie/$peliculaId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  // Para buscar Peliculas en MovieDB Api

  Future<List<Pelicula>> buscarPelicula(String query) async {
    // Construir  URL para realizar peticion http
    final url = Uri.https(_url, '3/search/movie', {
          'api_key': _apikey, 
          'language': _language, 
          'query': query
    });

    return await _procesarRespuesta(url);
  }
}
