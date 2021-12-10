import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class Product with ChangeNotifier{
   
   final String? id;
   final String? title;
   final String? description;
   final double? price;
   final String? imageUrl;
   bool isFavorite;
   Product({
      this.id,
     required this.title,
     required this.description,
     required  this.price,
     required this.imageUrl,
     this.isFavorite = false
     });


     void Favstatus(bool status){
       isFavorite = status;
       notifyListeners();

     }



     Future<void> toggleFavorite(String? authToken,String? userId)async{
       var dio = Dio();
       final oldStatus = isFavorite;
       isFavorite = !isFavorite;
       notifyListeners();
       final url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/favorite/$userId/$id.json?auth=$authToken';
       try{
            final response = await dio.put(
       url,
       data: isFavorite,
       );
       if(response.statusCode!  >=400){
         Favstatus(oldStatus);
       }
       }catch(error){
         Favstatus(oldStatus);

       }

       

     }

}