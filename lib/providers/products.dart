import 'package:e_commerce/models/http_exception.dart';
import 'package:e_commerce/providers/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
class Products extends ChangeNotifier{
       String? authToken;
       String? userId;    
  void update(String? token,String? idUser){
      authToken = token;
      userId = idUser;
      notifyListeners();
    }   
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> get item{
    return [..._items];
  }
  List<Product> get favorite{
    return _items.where((prod) => prod.isFavorite).toList();
  }
    Product findById(String id){
        return _items.firstWhere((prod) =>prod.id == id );
    }
    Future<void>fetchAndSetProducts([bool filterByUser = false])async{
      final filterString = filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
      var url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString';
      try{
           final response =await http.get(Uri.parse(url));
           final extractedData = json.decode(response.body);
           if(extractedData ==null){
             return ;
           }
         url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/favorite/$userId.json?auth=$authToken';
         final favoriteResponse = await http.get(Uri.parse(url));
         final favoriteData = json.decode(favoriteResponse.body);

           final List<Product> loadedProducts = [];
           extractedData.forEach((prodId, prodData) {
             loadedProducts.add(Product(
               id: prodId,
               title: prodData['title'],
               description: prodData['description'],
               price: prodData['price'],
               imageUrl: prodData['imageUrl'],
               isFavorite: favoriteData == null?false:favoriteData[prodId] ?? false
             ));           
           });
           _items =loadedProducts;
           notifyListeners();
      }catch(error){
        throw error;
      }
    }
      Future<void>addProduct(Product product) async{
        final url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken';
        try{
         // Response response;
          var dio = Dio();
         final response = await dio.post(url,data:{
          'title': product.title, 
          'description': product.description,
          'imageUrl':product.imageUrl,
          'price':product.price,
          'creatorId':userId
          });
          final newProduct = Product(
            id: response.data['name'], 
            title: product.title,
            description: product.description, 
            price: product.price,
            imageUrl: product.imageUrl
        );
        _items.add(newProduct);
        notifyListeners();
        }catch(error){
          throw error;
        }
      }
  //   Future<void> addProduct(Product product)async{
  //      const url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/produc';
  //      try{
  //        Response response;
  //       var dio = Dio();
  //       await dio.post(url, data: {
  //        'title': product.title, 
  //        'description': product.description,
  //        'imageUrl':product.imageUrl,
  //        'price':product.price,
  //        'isFavorite':product.isFavorite,
         
  //      }catch(error){

  //      }


  //     //  Response response;
  //     //  var dio = Dio();
  //     //  return dio.post(url, data: {
  //     //    'title': product.title, 
  //     //    'description': product.description,
  //     //    'imageUrl':product.imageUrl,
  //     //    'price':product.price,
  //     //    'isFavorite':product.isFavorite,
  //     //    }
  //     //    ).then((value)  {
  //     //       final newProduct = Product(
  //     //       id: DateTime.now().toString(), 
  //     //       title: product.title,
  //     //       description: product.description, 
  //     //       price: product.price,
  //     //       imageUrl: product.imageUrl
  //     //   );
  //     //      _items.add(newProduct);
  //     //      notifyListeners();         
  //     //    }).catchError((error){
  //     //      throw error;
  //     //    });
  //   // http.post(Uri.parse(url),
    
  //   // body: json.encode({
  //   //       'title': product.title, 
  //   //       'description': product.description,
  //   //       'imageUrl':product.imageUrl,
  //   //       'price':product.price,
  //   //       'isFavorite':product.isFavorite,
  //   // }));

  //     //  print("Hello world");
     
  // }
    Future<void> updateProduct(String id,Product newProduct)async{
          final prodIndex = _items.indexWhere((prod) => prod.id==id);
          if(prodIndex>=0){
             final url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
              var dio = Dio();
             try{
               await dio.patch(url,data:{
                'title': newProduct.title, 
                'description': newProduct.description,
                'imageUrl':newProduct.imageUrl,
                'price':newProduct.price,            
              });
            _items[prodIndex] = newProduct;
            notifyListeners();
             }catch(error){
               throw error;
             }            
          }
          else{            
          }
    }
    Future<void> deleteProduct(String id)async{
      var dio = Dio();
       final url = 'https://e-commerce-f4dc3-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken';
       final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
       Product? existingProduct = _items[existingProductIndex];
      _items.removeAt(existingProductIndex);
      notifyListeners();
      try{
            final response = await  dio.delete(url);
            if(response.statusCode! >=400){
            _items.insert(existingProductIndex, existingProduct);
            notifyListeners();
     }
      }catch(error){
        _items.insert(existingProductIndex, existingProduct);
            notifyListeners();
            throw HTTPException("Something is wrong");
      }
     existingProduct = null;
    }
}