import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  debugPrint("______________SUCCESS SNACKBAR____________");
  debugPrint("Success Message: $message");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      hitTestBehavior: HitTestBehavior.opaque,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      content: SizedBox(
        height: 50,
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
              ),
              icon: Icon(Icons.close, color: Colors.white, size: 24,),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              tooltip: 'Dismiss',
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green.shade400,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}