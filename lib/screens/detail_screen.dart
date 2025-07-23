import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/haber.dart';
import '../core/local_storage.dart';

class DetailScreen extends StatefulWidget {
  final Haber haber;

  const DetailScreen({Key? key, required this.haber}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  bool isFav = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    LocalStorage.isFavorite(widget.haber.id.toString()).then((value) {
      setState(() {
        isFav = value;
      });
    });
  }

  void toggleFavorite() async {
    if (isFav) {
      await LocalStorage.removeFavorite(widget.haber.id.toString());
    } else {
      await LocalStorage.addFavorite(widget.haber.id.toString());
    }
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final haber = widget.haber;

    return Scaffold(
      appBar: AppBar(
        title: Text(haber.baslik),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(haber.resim),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Etkinlik Açıklaması'),
              Tab(text: 'Basın Yansımaları'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "${haber.tarih} | ${haber.saat}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Html(data: haber.aciklama),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: (haber.basin != null &&
                          haber.basin!.trim().isNotEmpty &&
                          haber.basin!.trim() != "null")
                      ? Html(data: haber.basin!)
                      : const Center(
                          child: Text("Basın yansımaları bulunamadı.")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
