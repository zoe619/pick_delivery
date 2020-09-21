

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
}