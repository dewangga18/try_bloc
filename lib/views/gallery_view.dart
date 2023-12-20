import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:try_bloc/bloc/app_state.dart';
import 'package:try_bloc/views/components/main_pop_menu.dart';
import 'package:try_bloc/views/components/storage_image_item.dart';

class GalleryView extends HookWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () {
              picker.pickImage(source: ImageSource.gallery).then((image) {
                if (image != null) {
                  context.read<AppBloc>().add(
                        const AppEventUploadImage(filePath: ''),
                      );
                }
              });
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopMenu(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children:
            images.map((image) => StorageImageItem(image: image)).toList(),
      ),
    );
  }
}
