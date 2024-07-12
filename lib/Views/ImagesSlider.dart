import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageAssetPaths;

  const ImageSlider({Key? key, required this.imageAssetPaths})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enableInfiniteScroll: true,
        pauseAutoPlayOnTouch: true,
        scrollDirection: Axis.horizontal,
      ),
      items: imageAssetPaths.map((path) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius:
                    BorderRadius.circular(10.0), // Đặt bo tròn các góc
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10.0), // Bo tròn các góc cho hình ảnh
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
