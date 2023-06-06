import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olio_evo/utils/expand_text.dart';
import 'package:olio_evo/widgets/widget_related_products.dart';
import 'package:provider/provider.dart';

import '../models/cart_request_model.dart';
import '../models/product.dart';
import '../provider/cart_provider.dart';
import '../provider/loader_provider.dart';
import '../utils/custom_stepper.dart';

class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget({Key key, this.data}) : super(key: key);

  Product data;
  int qty = 1;

  CartProducts cartProducts = new CartProducts();

  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            productImages(data.images, context),
            const SizedBox(height: 10),
            Visibility(
                visible: data.calculateDiscount() > 0,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Colors.green),
                    child: Text('Sconto: ${data.calculateDiscount()}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              data.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.attributes != null && data.attributes.isNotEmpty
                      ? ("${data.attributes[0].options.join("-")}${data.attributes[0].name}")
                      : "",
                ),
                Text(
                  data.salePrice != null && data.salePrice.isNotEmpty
                      ? '€ ${data.salePrice}'
                      : '€ ${data.regularPrice}',
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomStepper(
                  lowerLimit: 1,
                  upperLimit: 20,
                  stepValue: 1,
                  iconSize: 22.0,
                  value: qty,
                  onChanged: (value) {
                    cartProducts.quantity = value;
                    qty = value;
                  },
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(true);
                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);

                    cartProducts.productId = data.id;
                    cartProducts.quantity = qty;
                    cartProvider.addToCart(cartProducts, (val) {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(false);
                      print(val);
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.redAccent,
                    //bordi del bottone
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Aggiungi al carrello",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            ExpandText(
                labelHeader: "Descrizione",
                desc: data.description,
                shortDesc: data.shortDescription),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            WidgetRelatedProducts(
              labelName: "Prodotti correlati",
              products: this.data.relatedIds,
            )
          ],
        ),
      ]),
    ));
  }

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index, realIndex) {
                return Center(
                  child: Image.network(
                    images[index].src,
                    fit: BoxFit.fill,
                  ),
                );
              },
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1),
              carouselController: _controller,
            ),
          ),
          Positioned(
            top: 100,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width - 80,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          )
        ],
      ),
    );
  }
}
