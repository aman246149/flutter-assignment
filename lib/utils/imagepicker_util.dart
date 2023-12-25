import 'dart:developer';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ispy/widgets/hspace.dart';
import 'package:ispy/widgets/vspace.dart';




class ImagePickerUtil {
  XFile? _selectedImagePath = XFile("");
  File _pickedImage = File("");
  final ImagePicker _pickedFile = ImagePicker();
List<XFile> multiMedia=[];
  void showImagePicker(BuildContext context, Function() updateState,{bool isMultiMediaPickerRequired=false}) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                     if(isMultiMediaPickerRequired){
                      setMultiMediaPicker(updateState);
                      Navigator.pop(context);
                      return;
                    }
                    getImage(ImageSource.camera, context, updateState);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffD0D0D0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          color: Color(0xff0A84FF),
                        ),
                        const HSpace(5),
                        Text(
                          "Take photo from camera",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff0A84FF)),
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 0.6,
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: () async{
                    if(isMultiMediaPickerRequired){
                      setMultiMediaPicker(updateState);
                      Navigator.pop(context);
                      return;
                    }
                    getImage(ImageSource.gallery, context, updateState);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xffD0D0D0),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.photo_size_select_actual,
                          color: Color(0xff0A84FF),
                        ),
                        const HSpace(5),
                        Text(
                          "Select from Gallery",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff0A84FF)),
                        )
                      ],
                    ),
                  ),
                ),
                const VSpace(8),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff0A84FF)),
                        ),
                      )),
                ),
                const VSpace(10),
              ],
            ),
          );
        });
  }

  void getImage(ImageSource imageSource, BuildContext context,
      Function() updateState) async {
    try {
      _selectedImagePath = (await _pickedFile.pickImage(source: imageSource));
      if (_selectedImagePath != null) {
        // double imageSize =
        //     calculateSizeInMb(await _selectedImagePath!.length());
        // if (imageSize > 5) {
        //   // ignore: use_build_context_synchronously
        //   showErrorSnackbar(context, "File size must be less than 5MB");
        //   return;
        // }
        _pickedImage = File(_selectedImagePath?.path ?? "");
      }
      updateState();
    } catch (e) {
      log(e.toString());
    }
  }

  void uploadImage(BuildContext context, Function() uploadApi,
      String keyName) async {
    

    if (_pickedImage.path.isNotEmpty) {
     
    }
  }

  File pickedImage() {
    return _pickedImage;
  }

  void setMultiMediaPicker(Function() updateState)async{
    final List<XFile> medias = await _pickedFile.pickMultiImage();
      multiMedia=medias;    
      updateState();  
  }


}
