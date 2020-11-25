import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/campaignOption.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/campaign/payments/creditcardform.dart';
import 'package:matchub_mobile/screens/campaign/view_campaign.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  CampaignOption donationOption;
  Project project;
  String selectedAmount;
  PaymentScreen({this.donationOption, this.selectedAmount, this.project});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51Hic4XKd47pTgnBudVK0lNYhoNfdHiXOFiI8OQeI4W98p2tVePbMdUb19c6Y37pc7ZaM8zF3pmiq33IkwRjtuWH500C0LfO6I0",
        merchantId: "Test",
        androidPayMode: 'test'));
    initialisePaymentIntent();
    super.initState();
  }

  final CreditCard testCard = CreditCard(
      number: '4242424242424242', expMonth: 12, expYear: 21, name: "Mark Tan");
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  String _currentSecret = null; //set this yourself, e.g using curl
  PaymentIntentResult _paymentIntent;

  Profile payTo;
  bool _isPaying = false;

  initialisePaymentIntent() async {
    var responseData = await ApiBaseHelper.instance.getProtected(
        "authenticated/getAccount/${widget.project.projCreatorId}");
    payTo = Profile.fromJson(responseData);

    final response = await ApiBaseHelper.instance
        .postProtected("authenticated/createPaymentIntent",
            body: json.encode({
              "amountInCents": double.parse(widget.selectedAmount) * 100,
              "payeeStripeUid": payTo.stripeAccountUid,
              "donationOptionId": widget.donationOption.donationOptionId,
              "paymentScenario": "FundCampaignDonation",
              "receiptEmail": "ikjun@gmail.com"
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
    setState(() => _isPaying = true);
    print(_currentSecret);
    print(_paymentMethod.id);
    StripePayment.confirmPaymentIntent(
      PaymentIntent(
          clientSecret: _currentSecret,
          paymentMethodId: _paymentMethod.id,),
    ).then((paymentIntent) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Thank you for your kind donation!'),
        duration: Duration(seconds: 2),
      ));
      Future.delayed(
          Duration(milliseconds: 2500), () => Navigator.pop(context));
      setState(() {
        _paymentIntent = paymentIntent;
        _isPaying = false;
      });
    });
  }

  // void setError(dynamic error) {
  //   _scaffoldKey.currentState
  //       .showSnackBar(SnackBar(content: Text(error.toString())));
  //   setState(() {
  //     _error = error.toString();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
                          "Pledge",
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
                          Text("Donation Selection",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[850],
                                  fontSize: 2 * SizeConfig.textMultiplier)),
                          SizedBox(height: 10),
                          Text(
                            widget.donationOption.optionDescription,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[850],
                                fontSize: 1.7 * SizeConfig.textMultiplier),
                          ),
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
                                "S\$ " + widget.selectedAmount + ".00",
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                        onPressed:
                            _paymentMethod == null || _currentSecret == null
                                ? null
                                : confirmPayment),
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
