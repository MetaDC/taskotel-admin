import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DynamicPagination extends StatelessWidget {
  const DynamicPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons = [];

    // Previous Button
    pageButtons.add(
      _navButton(
        label: 'Previous',
        enabled: currentPage > 1,
        onPressed: () => onPageChanged(currentPage - 1),
      ),
    );

    // Always show Page 1
    pageButtons.add(_pageButton(1, isCurrent: currentPage == 1));

    // Show ellipsis if gap between page 1 and start of middle range
    int start = currentPage - 1;
    int end = currentPage + 1;

    if (start > 2) {
      pageButtons.add(const _Ellipsis());
    }

    // Clamp middle range
    for (int i = start; i <= end; i++) {
      if (i > 1 && i < totalPages) {
        pageButtons.add(_pageButton(i, isCurrent: currentPage == i));
      }
    }

    // Show ellipsis if gap between end of middle and last page
    if (end < totalPages - 1) {
      pageButtons.add(const _Ellipsis());
    }

    // Always show last page
    bool enableLastPage = currentPage >= totalPages - 1;
    pageButtons.add(
      _pageButton(
        totalPages,
        isCurrent: currentPage == totalPages,
        enabled: enableLastPage,
      ),
    );

    // Next Button
    pageButtons.add(
      _navButton(
        label: 'Next',
        enabled: currentPage < totalPages,
        onPressed: () => onPageChanged(currentPage + 1),
      ),
    );

    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xffd5d9d9)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: pageButtons,
        ),
      ),
    );
  }

  Widget _pageButton(int page, {bool isCurrent = false, bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? () => onPageChanged(page) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCurrent ? Colors.black : Colors.transparent,
          ),
          color: Colors.white,
        ),
        child: Text(
          '$page',
          style: GoogleFonts.inter(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
            color: enabled ? const Color(0xff3E3E3E) : const Color(0xffCBCBCB),
          ),
        ),
      ),
    );
  }

  Widget _navButton({
    required String label,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(
        label == 'Next'
            ? CupertinoIcons.chevron_right
            : CupertinoIcons.chevron_back,
        color: enabled ? const Color(0xff3E3E3E) : const Color(0xffCBCBCB),
      ),
      iconAlignment: label == 'Next' ? IconAlignment.end : null,
      onPressed: enabled ? onPressed : null,
      style: ButtonStyle(
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(
          enabled ? const Color(0xff3E3E3E) : const Color(0xff929292),
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontWeight: enabled ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
          letterSpacing: .8,
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text("..."),
    );
  }
}

/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicPagination extends StatelessWidget {
  const DynamicPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons = [];

    // Previous Button
    pageButtons.add(_navButton(
      label: 'Previous',
      enabled: currentPage > 1,
      onPressed: () => onPageChanged(currentPage - 1),
    ));

    // Page 1
    pageButtons.add(_pageButton(1, isCurrent: currentPage == 1));

    // Ellipsis before
    if (currentPage > 4) {
      pageButtons.add(const _Ellipsis());
    }

    // Show up to 3 pages before current
    for (int i = currentPage - 3; i < currentPage; i++) {
      if (i > 1) {
        pageButtons.add(_pageButton(i));
      }
    }

    // Current Page
    if (currentPage != 1 && currentPage != totalPages) {
      pageButtons.add(_pageButton(currentPage, isCurrent: true));
    }

    // One page ahead
    if (currentPage + 1 < totalPages) {
      pageButtons.add(_pageButton(currentPage + 1));
    }

    // Ellipsis after
    if (currentPage + 2 < totalPages) {
      pageButtons.add(const _Ellipsis());
    }

    // Last Page
    // if (currentPage != totalPages) {
    pageButtons.add(_pageButton(totalPages,
        isCurrent: currentPage == totalPages,
        enabled: currentPage >= (totalPages - 1)));
    // }

    // Next Button
    pageButtons.add(_navButton(
      label: 'Next',
      enabled: currentPage < totalPages,
      onPressed: () => onPageChanged(currentPage + 1),
    ));

    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Color(0xffd5d9d9))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: pageButtons,
        ),
      ),
    );
  }

  Widget _pageButton(int page, {bool isCurrent = false, bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? () => onPageChanged(page) : null,
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          border:
              Border.all(color: isCurrent ? Colors.black : Colors.transparent),
          color: /* isCurrent ? Colors.grey.shade200 : */ Colors.white,
          // borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$page',
          style: GoogleFonts.inter(
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: enabled ? Color(0xff3E3E3E) : Color(0xffCBCBCB)),
        ),
      ),
    );
  }

  Widget _navButton({
    required String label,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(
        label == 'Next'
            ? CupertinoIcons.chevron_right
            : CupertinoIcons.chevron_back,
        color: enabled ? Color(0xff3E3E3E) : Color(0xffCBCBCB),
      ),
      iconAlignment: label == 'Next' ? IconAlignment.end : null,
      onPressed: enabled ? onPressed : null,
      style: ButtonStyle(
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStatePropertyAll(
            enabled ? Color(0xff3E3E3E) : Color.fromARGB(255, 146, 146, 146)),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      label: Text(
        label,
        style: GoogleFonts.inter(
            fontWeight: enabled ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
            letterSpacing: .8),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text("..."),
    );
  }
}
 */
