import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/products.dart';


class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Products>(context);
    return CarouselSlider.builder(
      itemCount: data.item.length, 
      itemBuilder:(context,index,realIndex){
        final imageUrl = data.item[3].imageUrl;
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            ),
          ),
        );
      },
       options: CarouselOptions(
         height: 200,     
         autoPlay: true,
        // viewportFraction: 1,
         enlargeCenterPage: true,
         enlargeStrategy: CenterPageEnlargeStrategy.height

         
       )
       );
  }
}