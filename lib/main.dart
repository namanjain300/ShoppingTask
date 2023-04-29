import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:testapplication/API/api_manager.dart';
import 'package:testapplication/model/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Shopping'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> products = [];

  Future getData() async {
    List response = await ApiManager().httpGet(
      'https://fakestoreapi.com/products',
    );
    if (response != null) {
      for (var v in response) {
        products.add(Product.fromMap(v));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.blue, fontSize: 22),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (products.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                );
              } else {
                return MasonryGridView.count(
                  itemCount: products.length,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  crossAxisCount: 2,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CachedNetworkImage(
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.cyan),
                                  value: progress.totalSize != null
                                      ? progress.progress
                                      : null,
                                ),
                              );
                            },
                            imageUrl: products[index].image,
                          ),
                        ),
                        Text(
                          products[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          products[index].description,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          products[index].category,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "USD ${products[index].price.toString()}",
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingBarIndicator(
                              itemSize: 14,
                              rating: products[index].rating.rate,
                              itemBuilder: (context, index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                );
                              },
                            ),
                            Text(
                              '(${products[index].rating.count.toString()})',
                              maxLines: 2,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
