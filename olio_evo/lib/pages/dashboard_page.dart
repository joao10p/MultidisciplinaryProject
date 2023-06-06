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
      child: ListView(children: [
        imageCarousel(context),
        WidgetHomeProducts(
            labelName: "Offerte di oggi", tagId: Config.offerteDiOggiTagId),
        WidgetHomeProducts(
            labelName: "I più Venduti", tagId: Config.topSellingTagId),
        WidgetHomeProducts(
            labelName: "I più Amati ", tagId: Config.iPiuAmatiTagId),
      ]),
    ));
  }

  Widget imageCarousel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.95,
      height: 220,
      child: Carousel(
        //overlayShadow: false,
        borderRadius: true,
        boxFit: BoxFit.contain,
        autoplay: true,
        autoplayDuration: Duration(seconds: 7),
        dotSize: 3.0,
        images: [
          FittedBox(
            fit: BoxFit.fill,
            child: Image.asset("assets/images/pubblicita_olio_1.jpg"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.asset("assets/images/pubblicita_olio_2.jpg"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.asset("assets/images/pubblicita_olio_3.jpg"),
          ),
        ],
      ),
    );
  }
}
