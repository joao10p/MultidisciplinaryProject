import 'package:flutter/material.dart';
import 'package:olio_evo/pages/about_us_page.dart';
import 'package:olio_evo/pages/contact_page.dart';
import 'package:olio_evo/pages/invite_friends_page.dart';
import 'package:olio_evo/pages/orders_page.dart';
import 'package:olio_evo/pages/profile_settings_page.dart';
import 'package:olio_evo/shared_service.dart';

import '../models/login_model.dart';
import '../widgets/unauth_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class OptionList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;

  OptionList(
      {this.optionIcon, this.optionTitle, this.optionSubTitle, this.onTap});
}

class _AccountPageState extends State<AccountPage> {
  List<OptionList> options = List<OptionList>.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedService.isLoggedIn(),
        // ignore: missing_return
        builder: (
          BuildContext context,
          AsyncSnapshot<bool> loginModel,
        ) {
          if (loginModel.hasData) {
            if (loginModel.data != null && loginModel.data) {
              return _listView(context);
            } else {
              return const UnAuthWidget();
            }
          } else {
            return const Text("No data");
          }
        });
  }

  Widget _buildRow(OptionList optionList, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(optionList.optionIcon, size: 30),
        ),
        // ignore: void_checks
        onTap: () {
          return optionList.onTap();
        },
        title: Text(
          optionList.optionTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Text(
            optionList.optionSubTitle,
            style: const TextStyle(color: Colors.redAccent, fontSize: 14),
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return FutureBuilder(
      future: SharedService.loginDetails(),
      builder:
          (BuildContext context, AsyncSnapshot<LoginResponseModel> loginModel) {
        if (loginModel.hasData) {
          return Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 5, 4, 0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.25,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border(
                              
                            )
                          ),
                          child: Image.asset("assets/images/olivevo_logo.jpg",
                              fit: BoxFit.cover),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(2, 2, 2, 4),
                        child: Text(
                          "Ciao, Vittorio!",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(3),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
                              child: Container(
                                height:MediaQuery.of(context).size.height * 0.06,
                                child: ListTile(
                                  tileColor: const Color(0xffffffff),
                                  title: const Text(
                                    "I miei Ordini",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  dense: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  selected: false,
                                  selectedTileColor: const Color(0x42000000),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    side: BorderSide(
                                        color: Colors.grey[700], width: 1),
                                  ),
                                  leading: const Icon(Icons.work_outline,
                                      color: Color(0xff212435), size: 24),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      color: Color(0xff212435), size: 24),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrdersPage()));
                                  },
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Container(
                              height:  MediaQuery.of(context).size.height*0.06,
                              child: ListTile(
                                tileColor: const Color(0x00000000),
                                title: const Text(
                                  "Modifica Profilo",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                dense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 4),
                                selected: false,
                                selectedTileColor: const Color(0x42000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                        color: Colors.grey[700], width: 1),
                                ),
                                leading: const Icon(Icons.settings,
                                    color: Color(0xff212435), size: 24),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xff212435), size: 24),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileSettingsPage()));
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Container(
                              height:  MediaQuery.of(context).size.height*0.06,
                              child: ListTile(
                                tileColor: const Color(0x00000000),
                                title: const Text(
                                  "Metodo di pagamento",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                dense: false,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                selected: false,
                                selectedTileColor: const Color(0x42000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                        color: Colors.grey[700], width: 1),
                                ),
                                leading: const Icon(Icons.credit_card,
                                    color: Color(0xff212435), size: 24),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xff212435), size: 24),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Container(
                              height:  MediaQuery.of(context).size.height*0.06,
                              child: ListTile(
                                tileColor: const Color(0x00000000),
                                title: const Text(
                                  "Indirizzo di spedizione",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                dense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 4),
                                selected: false,
                                selectedTileColor: const Color(0x42000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                        color: Colors.grey[700], width: 1),
                                ),
                                leading: const Icon(Icons.location_on,
                                    color: Color(0xff212435), size: 24),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xff212435), size: 24),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Container(
                              height:  MediaQuery.of(context).size.height*0.06,
                              child: ListTile(
                                tileColor: const Color(0x00000000),
                                title: const Text(
                                  "Invita Amici e Ottieni Ricompense!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                dense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 4),
                                selected: false,
                                selectedTileColor: const Color(0x42000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                        color: Colors.grey[700], width: 1),
                                ),
                                leading: const Icon(Icons.favorite_border,
                                    color: Color(0xff000000), size: 24),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xff212435), size: 24),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OffersPage()));
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Container(
                              height:  MediaQuery.of(context).size.height*0.06,
                              child: ListTile(
                                tileColor: const Color(0x00000000),
                                title: const Text(
                                  "Supporto",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                dense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 4),
                                selected: false,
                                selectedTileColor: const Color(0x42000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                        color: Colors.grey[700], width: 1),
                                ),
                                leading: const Icon(Icons.help_outline,
                                    color: Color(0xff212435), size: 24),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xff212435), size: 24),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContactPage()));
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                            child: Container(
                              height:  MediaQuery.of(context).size.height*0.06,
                              child: ListTile(
                                tileColor: const Color(0x00000000),
                                title: const Text(
                                  "About Us",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                dense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 4),
                                selected: false,
                                selectedTileColor: const Color(0x42000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                        color: Colors.grey[700], width: 1),
                                ),
                                leading: const Icon(Icons.info_outline,
                                    color: Color(0xff212435), size: 24),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    color: Color(0xff212435), size: 24),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AboutPage()));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: MaterialButton(
                          onPressed: () {
                            SharedService.logout()
                                .then((value) => {setState(() {})});
                          },
                          color: const Color(0xff000000),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: const BorderSide(
                                color: Color(0xff808080), width: 1),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          textColor: const Color(0xffffffff),
                          height: 40,
                          minWidth: 140,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Login model has no data"),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                SharedService.logout().then((value) => {setState(() {})});
              },
            )
          ],
        ));
      },
    );
  }
}
