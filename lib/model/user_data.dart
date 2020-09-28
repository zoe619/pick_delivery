

import 'package:flutter/material.dart';

class UserData extends ChangeNotifier
{

    String currentUserId;
    String pickAddress;
    String deliveryAddress;
    double pickLatitude;
    double pickLongitude;
    double deliveryLatitude;
    double deliveryLongitude;
    double distance;
    String pickItem;
    String riderName;
    String riderEmail;
    String riderPhone;
    String amount;
    String deliveryName;
    String deliveryEmail;
    String deliveryPhone;
    String note;
}