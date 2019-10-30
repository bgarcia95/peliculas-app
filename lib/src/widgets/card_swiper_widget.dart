import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  final List<dynamic> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              "https://larepublica.pe/resizer/AE4Cl6n8InP7xuQeJXm0WZarunM=/1200x660/top/arc-anglerfish-arc2-prod-gruporepublica.s3.amazonaws.com/public/NWL5VBI4A5FKHDK7ML3QYDCH7U.jpg",
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: peliculas.length,

        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
