import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olio_evo/config.dart';
import 'package:olio_evo/widgets/widget_home_sapori_regioni.dart';
import 'package:olio_evo/widgets/widget_home_products.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: ListView(
        children: [
       // imageCarousel(context),
        WidgetCategories(),
        WidgetHomeProducts(labelName: "Offerte di oggi", tagId:Config.offerteDiOggiTagId),
        WidgetHomeProducts(labelName: "I più Venduti", tagId:Config.topSellingTagId),
        WidgetHomeProducts(labelName: "I più Amati ", tagId:Config.iPiuAmatiTagId),

      ]),
    ));
  }

  Widget imageCarousel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Carousel(
        overlayShadow: false,
        borderRadius: true,
        boxFit: BoxFit.none,
        autoplay: true,
        dotSize: 4.0,
        images: [
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "https://www.lucianopignataro.it/wp-content/uploads/2022/02/Olio-Campania-igt.jpg"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "https://olivoeolio.edagricole.it/wp-content/uploads/sites/17/2020/07/olive-e-olio.jpg"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnznmgY-zvCCEI3In_dYdKV1rp9mrYoH58MQ&usqp=CAU"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "https://olivoeolio.edagricole.it/wp-content/uploads/sites/17/2020/07/olive-e-olio.jpg"),
          )
        ],
      ),
    );
  }
}
