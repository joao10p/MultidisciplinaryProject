class PaymentMethod{
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;

  PaymentMethod (
    this.id,
    this.name,
    this.description,
    this.logo,
    this.route,
    this.onTap,
    this.isRouteRedirect,
);

}

class PaymentMethodList {
  List<PaymentMethod> paymentsList;
  List<PaymentMethod> _cashList;
                        
  PaymentMethodList() {
   this.paymentsList = [
    new PaymentMethod(
      "paypal",
      "PayPal",
      "Click to pay with Paypal Method",
      "assets/images/paypal.png",
      "/PayPal",
      (){},
      true,
    ),
   ];

   this._cashList =[
    new PaymentMethod(
      "cod",
      "Cash on Delivery",
      "Click to pay with cash on delivery",
      "assets/images/cash.png",
      "/OrderSuccess",
      (){},
      false,
    ),
   ];
  }

  List<PaymentMethod> get paymentList => paymentList;
  List<PaymentMethod> get cashList => _cashList;

}