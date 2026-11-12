
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:picsum_gallery/main.dart';
import 'package:picsum_gallery/providers/gallery_provider.dart';

void main() {
  testWidgets('Picsum Gallery app loads successfully',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (_) => GalleryProvider(),
            child: const PicsumGalleryApp(),
          ),
        );

        expect(find.text('Picsum Gallery'), findsOneWidget);
      });
}
