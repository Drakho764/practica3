import 'package:flutter/material.dart'; //1
import 'package:provider/provider.dart';
import 'package:proyecto/database/agendadb.dart';
import 'package:proyecto/models/popular_model.dart';
import 'package:proyecto/network/api_popular.dart';
import 'package:proyecto/provider/test_provider.dart';
import 'package:proyecto/screens/detail_movie_screen.dart';
import 'package:proyecto/widgets/item_movie.dart'; //8

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  AgendaDB? agendaDB;
  ApiPopular? apiPopular;
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    agendaDB = AgendaDB();
  }

  @override
  Widget build(BuildContext context) {
    TestProvider flag = Provider.of<TestProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Peliculas Populares"),
        ),
        body: FutureBuilder(
            future: flag.getupdatePosts() == true
                ? favoriteCount == 0
                    ? agendaDB!.GETALLPOPULAR()
                    : apiPopular!.getAllPopular()
                : favoriteCount == 1
                    ? agendaDB!.GETALLPOPULAR()
                    : apiPopular!.getAllPopular(),
            builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
              if (snapshot.data != null) {
                if (snapshot.data!.isNotEmpty) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      childAspectRatio: .8,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      PopularModel model = snapshot.data![index];
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailMovieScreen(model: model)));
                          },
                          child:Hero(tag: model, child: ItemPopularMovie(
                              popularModel: snapshot.data![index])) 
                          
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Algo salio mal :()'),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                    itemCount: snapshot.data != null
                        ? snapshot.data!.length
                        : 0, //snapshot.data!.length,
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Esta muy vacio por aqui :|',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              }
              return Container();

            }));
  }
}
