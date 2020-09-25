

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
    String pickPhone;
    String riderName;
    String riderEmail;
    double amount;
}