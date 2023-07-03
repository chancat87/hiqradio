import 'package:flutter/material.dart';
import 'package:hiqradio/src/utils/check_license.dart';
import 'package:hiqradio/src/utils/constant.dart';
import 'package:hiqradio/src/views/components/ink_click.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Activate extends StatefulWidget {
  final Function(String, String) onActivate;
  const Activate({super.key, required this.onActivate});

  @override
  State<Activate> createState() => _ActivateState();
}

class _ActivateState extends State<Activate> {
  final TextEditingController editingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color toastColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      width: 484,
      height: 120,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            child: Text(
              // '请输入激活码(邮件至$kAuthor索取)：',
              AppLocalizations.of(context).cfg_activate_msg(kAuthor),
              style: const TextStyle(fontSize: 15.0),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  // width: 360,
                  height: 48,
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: TextField(
                    onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
                    controller: editingController,
                    focusNode: focusNode,
                    autofocus: true,
                    obscureText: false,
                    autocorrect: false,
                    obscuringCharacter: '*',
                    cursorWidth: 1.0,
                    cursorColor: Theme.of(context).textTheme.bodyMedium!.color!,
                    style: const TextStyle(fontSize: 15.0),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!),
                            borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!),
                            borderRadius: BorderRadius.circular(5)),
                        contentPadding: const EdgeInsets.all(2.0)),
                    onSubmitted: (text) {
                      focusNode.requestFocus();
                      onSubmitted(toastColor);
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              InkClick(
                  onTap: () => onSubmitted(toastColor),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    alignment: Alignment.center,
                    child: Text(
                      // '激活',
                      AppLocalizations.of(context).cfg_activate,

                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void onSubmitted(Color backgroundColor) async {
    String license = editingController.text.trim();
    if (license.isEmpty || license.length != 32) {
      showToast(
        // '请输入正确的32位激活码',
        AppLocalizations.of(context).cfg_input_correct_code,
        backgroundColor: backgroundColor,
        position: const ToastPosition(
          align: Alignment.bottomCenter,
        ),
      );
      return;
    }
    String? expireDate =
        await CheckLicense.instance.isActiveLicense(kProductId, license);
    if (expireDate == null) {
      showToast(
        // '激活码无效',
        AppLocalizations.of(context).cfg_invalid_code,

        backgroundColor: backgroundColor,
        position: const ToastPosition(
          align: Alignment.bottomCenter,
        ),
      );
      return;
    }
    widget.onActivate.call(license, expireDate);
  }
}