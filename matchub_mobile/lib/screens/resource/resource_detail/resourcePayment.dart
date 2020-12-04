import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/campaign/payments/creditcardform.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageResource.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/appExpansionTile.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../../sizeConfig.dart';

class ResourcePayment extends StatefulWidget {
  static const routeName = "/payment-form";
  Resources resource;
  ResourcePayment({this.resource});

  @override
  _ResourcePaymentState createState() => _ResourcePaymentState();
}

class _ResourcePaymentState extends State<ResourcePayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51Hic4XKd47pTgnBudVK0lNYhoNfdHiXOFiI8OQeI4W98p2tVePbMdUb19c6Y37pc7ZaM8zF3pmiq33IkwRjtuWH500C0LfO6I0",
        merchantId: "Test",
        androidPayMode: 'test'));

    super.initState();
  }

  final CreditCard testCard = CreditCard(
      number: '4242424242424242', expMonth: 11, expYear: 23, name: "KAIKAI");
  PaymentMethod _paymentMethod;
  Profile payTo;
  Profile payer;
  bool _isPaying = false;
  String _error;
  String _currentSecret = null;
  Token _paymentToken;
  PaymentIntentResult _paymentIntent;
  num selectedProjectId;
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  String foos = 'Select project';
  List<Project> projects;
  initialisePaymentIntent() async {
    var responseData = await ApiBaseHelper.instance.getProtected(
        "authenticated/getAccount/${widget.resource.resourceOwnerId}");
    payTo = Profile.fromJson(responseData);
    payer = Provider.of<Auth>(context, listen: false).myProfile;
    final response = await ApiBaseHelper.instance
        .postProtected("authenticated/createPaymentIntent",
            body: json.encode({
              "amountInCents": widget.resource.price * 100,
              "payeeStripeUid": payTo.stripeAccountUid,
              "resourceId": widget.resource.resourceId,
              "projectId": selectedProjectId,
              "paymentScenario": "ResourcePurchase",
              "receiptEmail": payer.email,
            }));
    print(response);
    _currentSecret = response['client_secret'];
    StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: testCard,
      ),
    ).then((paymentMethod) {
      setState(() {
        _paymentMethod = paymentMethod;
      });
    });
  }

  confirmPayment() async {
    getResources();
    await Provider.of<Auth>(context, listen: false).retrieveUser();
    setState(() => _isPaying = true);
    print(_currentSecret);
    print(_paymentMethod.id);
    StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: _currentSecret,
        paymentMethodId: _paymentMethod.id,
      ),
    ).then((paymentIntent) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Payment successful!'),
        duration: Duration(seconds: 2),
      ));
      setState(() {
        _paymentIntent = paymentIntent;
        _isPaying = false;
      });
      Future.delayed(
          Duration(milliseconds: 2500), () => Navigator.pop(context));
    });
  }

  getResources() async {
    await Provider.of<ManageResource>(this.context, listen: false)
        .getResourceById(widget.resource.resourceId);
  }

  @override
  Widget build(BuildContext context) {
    projects = Provider.of<Auth>(context).myProfile.projectsOwned;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isPaying,
          color: Colors.blueGrey[200].withOpacity(0.3),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment for resource",
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontWeight: FontWeight.w600,
                              fontSize: 3 * SizeConfig.textMultiplier),
                        ),
                        FlatButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[400],
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 100 * SizeConfig.widthMultiplier,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey[400]),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.resource.resourceName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[850],
                                  fontSize: 3 * SizeConfig.textMultiplier)),
                          Text(widget.resource.resourceDescription,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[850],
                                  fontSize: 2 * SizeConfig.textMultiplier)),
                          SizedBox(height: 10),
                          Divider(
                              color: Colors.grey[400],
                              height: 24,
                              thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[850],
                                    fontSize: 2.5 * SizeConfig.textMultiplier),
                              ),
                              Text(
                                "S\$ " + widget.resource.price.toString() + "0",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kKanbanColor,
                                    fontSize: 2.5 * SizeConfig.textMultiplier),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "MATCH RESOURCE TO:",
                        ),
                      ],
                    ),
                    AppExpansionTile(
                        key: expansionTile,
                        title: new Text(this.foos),
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.025),
                        children: <Widget>[
                          for (Project p in projects) ...{
                            new ListTile(
                              title: Text(p.projectTitle),
                              onTap: () {
                                setState(() {
                                  this.foos = p.projectTitle;
                                  selectedProjectId = p.projectId;
                                  expansionTile.currentState.collapse();
                                });
                                initialisePaymentIntent();
                              },
                            ),
                          },
                        ]),
                    CreditCardForm(
                      themeColor: kPrimaryColor,
                      cardHolderName: testCard.name,
                      cardNumber: testCard.number,
                      cvvCode: testCard.cvc,
                      expiryDate: "12/12",
                      onCreditCardModelChange: (data) =>
                          onCreditCardModelChange(data),
                    ),
                    CreditCardWidget(
                      cardNumber: testCard.number,
                      expiryDate: "12/12",
                      cardHolderName: testCard.name,
                      cvvCode: '250',
                      showBackView: false,
                      cardbgColor: Color(0xFF153F73),
                      height: 175,
                      textStyle: TextStyle(color: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      animationDuration: Duration(milliseconds: 1000),
                    ),
                    Divider(),
                    FlatButton(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: kKanbanColor,
                      minWidth: 100 * SizeConfig.widthMultiplier,
                      child: Text("Pay",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                      onPressed:
                          _paymentMethod == null || _currentSecret == null
                              ? null
                              : confirmPayment,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      testCard.number = creditCardModel.cardNumber;
      testCard.name = creditCardModel.cardHolderName;
    });
  }
}
