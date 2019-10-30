import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = 'f4d30dfea84b32afbba315fe5d1ed849';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Pelicula>> getEnCines() async {
    // Construir  URL para realizar peticion http
    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key' : _apikey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;

  }

}