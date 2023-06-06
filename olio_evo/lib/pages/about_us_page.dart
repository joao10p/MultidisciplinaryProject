import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(5, 60, 5, 10),
                child: Image.asset(
                  "assets/images/olivevo_logo.jpg",
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.cover,
                ),
              ),
            Text(
              "Storia",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                color: Color(0xff000000),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Text(
                "In 2023, Olivevo launched as a company with a mission to revolutionise the sale of olive oil. They introduced an innovative online platform where customers could browse and buy premium olive oils. A unique feature allowed customers to scan barcodes or upload photos of olive oil bottles to access detailed product information instantly. Supported by a chatbot, customers received personalised service throughout the shopping experience. Olivevo’s convenient and information-rich approach quickly made them a popular choice for olive oil enthusiasts, transforming the way people discover and buy olive oil.",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  color: Color(0xff222020),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Trasparente",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Color(0xff000000),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    child: Text(
                      "Olivevo, the olive oil reselling company, takes pride in providing its customers with a transparent and trustworthy website. From the moment customers land on the online platform, they are met with clarity and openness. Olivevo’s commitment to transparency is reflected in the comprehensive product descriptions and detailed information about each olive oil on offer, empowering customers to make informed decisions. The website’s user-friendly interface further enhances transparency by making it easy for customers to navigate and access the information they need. Olivevo’s transparent approach sets them apart in the industry, building trust and loyalty with their customers.",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Text(
                    "Obiettivo",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Color(0xff000000),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 30),
                    child: Text(
                      "The site is designed with high-level security measures to ensure the safety of customer information, from the moment they navigate the site to the payment process and beyond. Olivevo prioritises data protection and employs encryption protocols to protect sensitive information during transactions. Customers can browse the site with peace of mind, knowing that their personal data and payment information is protected. With Olivevo, you can enjoy a seamless and secure online shopping experience from start to finish.",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Text(
                    "Sicuro",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Color(0xff000000),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 30),
                    child: Text(
                      "Is fully verified by all relevant entities, including copyright authorities, data sharing rights organizations, and other important entities involved in website creation. With a strong commitment to compliance, Olivevo ensures that all legal requirements and regulations are met, providing a trustworthy and reliable online platform for its customers. By adhering to industry standards and working closely with regulatory bodies, Olivevo guarantees that its website is fully authorized, protecting both the company and its valued customers. You can shop with confidence, knowing that Olivevo operates within the legal framework and respects the rights of all stakeholders involved.",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Icon(
                            Icons.accessibility,
                            color: Color(0xff212435),
                            size: 35,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Icon(
                            Icons.admin_panel_settings,
                            color: Color(0xff212435),
                            size: 35,
                          ),
                        ),
                        Icon(
                          Icons.done,
                          color: Color(0xff212435),
                          size: 35,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
