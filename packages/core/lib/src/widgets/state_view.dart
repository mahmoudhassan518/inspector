import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common_cubit.dart';
import '../common/common_state.dart';

/// StateView - wrapper for pages with loading overlay and snackbar
class StateView extends StatelessWidget {
  final Widget? child;
  final CommonCubit? cubit;
  final bool showOverlayLoading;
  final WidgetBuilder? loadingBuilder;
  final Widget? loadingWidget;

  const StateView({
    super.key,
    this.child,
    this.cubit,
    this.showOverlayLoading = true,
    this.loadingBuilder,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCubit = cubit ?? context.read<CommonCubit>();

    return BlocBuilder<CommonCubit, CommonState>(
      bloc: effectiveCubit,
      builder: (context, state) {
        final baseChild = child ?? const SizedBox.shrink();
        final shouldUseShimmer =
            state.isLoading &&
            state.loadingPresentation == LoadingPresentation.shimmer &&
            loadingBuilder != null;
        final displayedChild = shouldUseShimmer ? loadingBuilder!(context) : baseChild;

        final children = <Widget>[displayedChild];

        final shouldShowOverlay =
            state.isLoading &&
            showOverlayLoading &&
            (state.loadingPresentation == LoadingPresentation.overlay ||
                (state.loadingPresentation == LoadingPresentation.shimmer && loadingBuilder == null));

        if (shouldShowOverlay) {
          children.add(
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.02),
                  child: Center(child: loadingWidget ?? const CircularProgressIndicator()),
                ),
              ),
            ),
          );
        }

        if (state.message != null && state.message!.isNotEmpty) {
          children.add(
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: _buildSnackBar(context, state, effectiveCubit),
            ),
          );
        }

        return Stack(clipBehavior: Clip.none, children: children);
      },
    );
  }

  Widget _buildSnackBar(BuildContext context, CommonState state, CommonCubit cubit) {
    final color = switch (state.level) {
      AlertType.success => Colors.green,
      AlertType.warning => Colors.orange,
      AlertType.destructive => Colors.red,
      AlertType.info => Colors.blue,
    };

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      color: color.shade50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                state.message ?? '',
                style: TextStyle(color: color.shade900),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.snackBarConfig.retryCallback != null)
              TextButton(
                onPressed: state.snackBarConfig.retryCallback,
                child: const Text('Retry'),
              ),
            if (state.snackBarConfig.showCloseIcon)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => cubit.clearSnackBar(),
              ),
          ],
        ),
      ),
    );
  }
}
