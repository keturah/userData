import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ProfileFormScreen extends StatefulWidget {
  static const String id = 'profile_form';

  @override
  _ProfileFormScreenState createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData _currentLoggedInUserData;
  bool showSpinner = false;

  //global declarations
  String selectedBusinessTypeDropDownValue = 'Fashion';
  String selectedCurrencyDropDownValue = 'NGN: Nigerian Naira';
  String selectedCountryDropDownValue = 'Nigeria';
  String email;

  TextEditingController _businessNameController = new TextEditingController();
  TextEditingController _streetAddressController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _tradingCurrencyController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();

    UserDataNotifier userDataNotifier =
        Provider.of<UserDataNotifier>(context, listen: false);

    if (userDataNotifier.currentLoggedInUserData != null) {
      _currentLoggedInUserData = userDataNotifier.currentLoggedInUserData;
    } else {
      _currentLoggedInUserData = UserData(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _saveUserData() async {
      UserDataNotifier userDataNotifier =
          Provider.of<UserDataNotifier>(context, listen: false);

      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
      try {
        showSpinner = true;

        await userDataNotifier.createOrUpdateUserData(
            _currentLoggedInUserData, true);
        setState(() {
          showSpinner = false;
        });

        Navigator.pop(context);
      } catch (e) {
        showSpinner = false;
        print('Error encountered: ${e.toString()}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          FlatButton(
              onPressed: () => _saveUserData(),
              child: Icon(
                FontAwesomeIcons.save,
                color: kThemeStyleButtonFillColour,
              )),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabelTextPadding(text: 'Business Information'),

                //business name
                RegularTextPadding(regText: 'Business Name'),
                _buildBusinessName(),

                //business type
                RegularTextPadding(regText: 'Business Type'),
                Platform.isIOS
                    ? _buildCupertinoStyleBusinessType(context)
                    : _buildMaterialStyleBusinessType(context),

                //Trading currency
                RegularTextPadding(regText: 'Trading Currency'),
                Platform.isIOS
                    ? _buildCupertinoStyleTradingCurrency(context)
                    : _buildMaterialStyleTradingCurrency(context),

                //business location
                RegularTextPadding(regText: 'Location'),
                //address 1
                _buildAddress(),
                //city
                _buildCityField(),
                //postcode
                _buildPostcode(),
                //state
                _buildStateField(),
                //country
                Platform.isIOS
                    ? _buildCupertinoStyleCountry(context)
                    : _buildMaterialStyleCountry(context),

                SizedBox(
                  height: 20.0,
                ),
                DividerClass(),
                SizedBox(
                  height: 20.0,
                ),

                //Personal information
                LabelTextPadding(text: 'Personal Information'),
                _buildFirstNameField(),
                _buildLastNameField(),
                _buildPhoneNumberField(),
                // _buildEmailField(),

                //cancel and save buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Buttons(
                          onPressedButton: () {
                            Navigator.pop(context);
                          },
                          buttonLabel: 'Cancel',
                          buttonColour: kThemeStyleButtonFillColour,
                          buttonTextStyle: kThemeStyleButton),
                      SizedBox(
                        width: 15.0,
                      ),
                      Buttons(
                          onPressedButton: () => _saveUserData(),
                          buttonLabel: 'Save',
                          buttonColour: kThemeStyleButtonFillColour,
                          buttonTextStyle: kThemeStyleButton),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //business information
  Widget _buildBusinessName() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        controller: _businessNameController,
        textAlign: TextAlign.left,
        onSaved: (value) {
          _currentLoggedInUserData.businessName = value;
        },
        validator: TextInputFieldValidator.validate,
        decoration:
            kTextFieldDecoration.copyWith(hintText: 'update business Name'),
      ),
    );
  }

  //business type - cupertino and material styles
  _buildCupertinoStyleBusinessType(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
              color: kThemeStyleButtonFillColour,
              width: 1,
            )),
        padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
        margin: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentLoggedInUserData.businessType == null
                ? selectedBusinessTypeDropDownValue
                : _currentLoggedInUserData.businessType),
            Icon(
              FontAwesomeIcons.caretDown,
              color: kThemeStyleButtonFillColour,
            ),
          ],
        ),
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).copyWith().size.height / 4,
            child: CupertinoPicker(
              magnification: 1.5,
              children: List<Widget>.generate(businessType.length, (int index) {
                return Center(
                  child: Text(
                    businessType[index].toString(),
                    softWrap: true,
                    style: TextStyle(fontSize: 15.0),
                  ),
                );
              }),
              itemExtent: 25,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedBusinessTypeDropDownValue = businessType[index];
                  _currentLoggedInUserData.businessType = businessType[index];
                });
              },
            ),
          );
        },
      ),
    );
  }

  _buildMaterialStyleBusinessType(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: kThemeStyleButtonFillColour,
            width: 1,
          )),
      margin: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: DropdownButton(
          value: _currentLoggedInUserData.businessType == null
              ? selectedBusinessTypeDropDownValue
              : _currentLoggedInUserData.businessType,
          elevation: 15,
          iconDisabledColor: kThemeStyleButtonFillColour,
          iconEnabledColor: kThemeStyleButtonFillColour,
          underline: Container(),
          items: businessType
              .map(
                (businessType) => DropdownMenuItem(
                    value: businessType, child: Text(businessType)),
              )
              .toList(),
          onChanged: (newValue) {
            setState(() {
              selectedBusinessTypeDropDownValue = newValue;
              _currentLoggedInUserData.businessType = newValue;
            });
          },
        ),
      ),
    );
  }

  //trading currency - cupertino and material styles
  _buildCupertinoStyleTradingCurrency(BuildContext context) {
    UserDataNotifier userDataNotifier =
        Provider.of<UserDataNotifier>(context, listen: false);

    _tradingCurrencyController.text =
        userDataNotifier.currentLoggedInUserData.businessTradingCurrency;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).copyWith().size.height / 4,
            child: CupertinoPicker(
              magnification: 1.5,
              children:
                  List<Widget>.generate(tradingCurrency.length, (int index) {
                return Center(
                  child: Text(
                    tradingCurrency[index].toString(),
                    softWrap: true,
                    style: TextStyle(fontSize: 15.0),
                  ),
                );
              }),
              itemExtent: 25,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedCurrencyDropDownValue = tradingCurrency[index];
                });
              },
            ),
          );
        },
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0.5)),
            border: Border.all(
              color: kThemeStyleButtonFillColour,
              width: 1,
            )),
        padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
        margin: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(selectedCurrencyDropDownValue),
            Icon(
              FontAwesomeIcons.caretDown,
              color: kThemeStyleButtonFillColour,
            ),
          ],
        ),
      ),
    );
  }

  _buildMaterialStyleTradingCurrency(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: kThemeStyleButtonFillColour,
            width: 1,
          )),
      margin: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: DropdownButton(
          value: _currentLoggedInUserData.businessTradingCurrency == null
              ? selectedCurrencyDropDownValue
              : _currentLoggedInUserData.businessTradingCurrency,
          icon: Icon(
            FontAwesomeIcons.caretDown,
            color: kThemeStyleButtonFillColour,
          ),
          elevation: 15,
          underline: Container(
            color: kThemeStyleButtonFillColour,
          ),
          items: tradingCurrency
              .map(
                (tradingCurrency) => DropdownMenuItem(
                    value: tradingCurrency, child: Text(tradingCurrency)),
              )
              .toList(),
          onChanged: (newValue) {
            setState(() {
              selectedCurrencyDropDownValue = newValue;
              _currentLoggedInUserData.businessTradingCurrency = newValue;
            });
          },
        ),
      ),
    );
  }

  //address field
  _buildAddress() {
    UserDataNotifier userDataNotifier =
        Provider.of<UserDataNotifier>(context, listen: false);
//    _streetAddressController.text =
//        userDataNotifier.currentLoggedInUserData.streetAddress;

    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
//        controller: _streetAddressController,
        textAlign: TextAlign.left,
        onSaved: (value) {
          userDataNotifier.currentLoggedInUserData.streetAddress = value;
          _streetAddressController.text = value;
        },
        validator: TextInputFieldValidator.validate,
        decoration:
            kTextFieldDecoration.copyWith(hintText: 'house and street address'),
      ),
    );
  }

  //city field
  _buildCityField() {
    UserDataNotifier userDataNotifier =
        Provider.of<UserDataNotifier>(context, listen: false);
//    _cityController.text = userDataNotifier.currentLoggedInUserData.city;

    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
//        controller: _cityController,
        textAlign: TextAlign.left,
        onSaved: (value) {
          userDataNotifier.currentLoggedInUserData.city = value;
          _cityController.text = value;
        },
        validator: TextInputFieldValidator.validate,
        decoration: kTextFieldDecoration.copyWith(hintText: 'enter city'),
      ),
    );
  }

  //postcode field
  _buildPostcode() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        initialValue: _currentLoggedInUserData.postcode,
        textAlign: TextAlign.left,
        onSaved: (value) {
          _currentLoggedInUserData.postcode = value;
        },
        validator: TextInputFieldValidator.validate,
        decoration: kTextFieldDecoration.copyWith(hintText: 'enter postcode'),
      ),
    );
  }

  //state field
  _buildStateField() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        initialValue: _currentLoggedInUserData.state,
        validator: TextInputFieldValidator.validate,
        textAlign: TextAlign.left,
        onSaved: (value) {
          _currentLoggedInUserData.state = value;
        },
        decoration: kTextFieldDecoration.copyWith(hintText: 'enter state'),
      ),
    );
  }

  //country field - cupertino and material styles
  _buildCupertinoStyleCountry(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).copyWith().size.height / 4,
            child: CupertinoPicker(
              magnification: 1.5,
              children: List<Widget>.generate(country.length, (int index) {
                return Center(
                  child: Text(
                    country[index].toString(),
                    softWrap: true,
                    style: TextStyle(fontSize: 15.0),
                  ),
                );
              }),
              itemExtent: 25,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedCountryDropDownValue = country[index];
                  _currentLoggedInUserData.country = country[index];
                });
              },
            ),
          );
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0.5)),
          border: Border.all(
            color: kThemeStyleButtonFillColour,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 12.0, 20.0, 12.0),
        margin: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentLoggedInUserData.country),
            Icon(
              FontAwesomeIcons.caretDown,
              color: kThemeStyleButtonFillColour,
            ),
          ],
        ),
      ),
    );
  }

  _buildMaterialStyleCountry(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: kThemeStyleButtonFillColour,
          width: 1,
        ),
      ),
      margin: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: DropdownButton(
          value: _currentLoggedInUserData.country == null
              ? selectedCountryDropDownValue
              : _currentLoggedInUserData.country,
          elevation: 15,
          iconDisabledColor: kThemeStyleButtonFillColour,
          iconEnabledColor: kThemeStyleButtonFillColour,
          underline: Container(),
          items: country
              .map(
                (country) =>
                    DropdownMenuItem(value: country, child: Text(country)),
              )
              .toList(),
          onChanged: (newValue) {
            setState(() {
              selectedCountryDropDownValue = newValue;
              _currentLoggedInUserData.country = newValue;
            });
          },
        ),
      ),
    );
  }

  //logged in user personal info build
  //first name
  _buildFirstNameField() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        initialValue: _currentLoggedInUserData.firstName,
        textAlign: TextAlign.left,
        onSaved: (value) {
          _currentLoggedInUserData.firstName = value;
        },
        validator: TextInputFieldValidator.validate,
        decoration: kTextFieldDecoration.copyWith(hintText: 'your first Name'),
      ),
    );
  }

  //last name
  _buildLastNameField() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        initialValue: _currentLoggedInUserData.lastName,
        textAlign: TextAlign.left,
        onSaved: (value) {
          _currentLoggedInUserData.lastName = value;
        },
        validator: TextInputFieldValidator.validate,
        decoration: kTextFieldDecoration.copyWith(hintText: 'your last name'),
      ),
    );
  }

  //phone number
  _buildPhoneNumberField() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: TextFormField(
        initialValue: _currentLoggedInUserData.phoneNumber,
        textAlign: TextAlign.left,
        onSaved: (value) {
          _currentLoggedInUserData.phoneNumber = value;
        },
        validator: TextInputFieldValidator.validate,
        decoration:
            kTextFieldDecoration.copyWith(hintText: 'your phone number'),
      ),
    );
  }
}

class TextInputFieldValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'This field can\'t be empty, you must enter a text';
    }
    if (value.length < 3) {
      return 'You must enter at least a word';
    }
    return value;
  }
}
