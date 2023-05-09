import 'package:flutter/material.dart';
import 'package:olio_evo/pages/dashboard_page.dart';
import 'package:olio_evo/shared_service.dart';
import 'package:olio_evo/widgets/unauth_widget.dart';

import '../models/login_model.dart';

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
    options.add(
      OptionList(
          optionIcon: Icons.shopping_cart,
          optionTitle: "Orders",
          optionSubTitle: "Check my orders",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardPage()));
          }),
    );
    options.add(
      OptionList(
          optionIcon: Icons.edit,
          optionTitle: "Edit Profile",
          optionSubTitle: "Update your profile",
          onTap: () {}),
    );
    options.add(
      OptionList(
          optionIcon: Icons.logout_sharp,
          optionTitle: "Sign out",
          optionSubTitle: "",
          onTap: () {
            SharedService.logout().then((value) => {setState(() {})});
          }),
    );
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
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
          padding: const EdgeInsets.only(top: 5),
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
                        padding: EdgeInsets.fromLTRB(4, 8, 4, 4),
                        child: Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset("assets/images/olivevo_logo.jpg",
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
                        child: Text(
                          "Ciao, vittorio!",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(3),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                            child: ListTile(
                              tileColor: Color(0xffffffff),
                              title: Text(
                                "Ordini",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              dense: false,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                              selected: false,
                              selectedTileColor: Color(0x42000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                              ),
                              leading: Icon(Icons.work_outline,
                                  color: Color(0xff212435), size: 20),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Color(0xff212435), size: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: ListTile(
                              tileColor: Color(0x00000000),
                              title: Text(
                                "Modifica Profilo",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                              dense: false,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                              selected: false,
                              selectedTileColor: Color(0x42000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                              ),
                              leading: Icon(Icons.settings,
                                  color: Color(0xff212435), size: 20),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Color(0xff212435), size: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: ListTile(
                              tileColor: Color(0x00000000),
                              title: Text(
                                "Cambia Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              dense: false,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                              selected: false,
                              selectedTileColor: Color(0x42000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                              ),
                              leading: Icon(Icons.lock,
                                  color: Color(0xff212435), size: 20),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Color(0xff212435), size: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: ListTile(
                              tileColor: Color(0x00000000),
                              title: Text(
                                "Invita Amici e Ottieni Ricompense!",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xff000000),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              dense: false,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                              selected: false,
                              selectedTileColor: Color(0x42000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                              ),
                              leading: Icon(Icons.favorite_border,
                                  color: Color(0xff000000), size: 20),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Color(0xff212435), size: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: ListTile(
                              tileColor: Color(0x00000000),
                              title: Text(
                                "Supporto",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              dense: false,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                              selected: false,
                              selectedTileColor: Color(0x42000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                              ),
                              leading: Icon(Icons.info_outline,
                                  color: Color(0xff212435), size: 20),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Color(0xff212435), size: 20),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: MaterialButton(
                          onPressed: () {},
                          color: Color(0xff000000),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(color: Color(0xff808080), width: 1),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          textColor: Color(0xffffffff),
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
