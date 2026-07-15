import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/booking_flow_provider.dart';
import 'booking_progress_bar.dart';
import 'package:kitchencall_customer/core/theme/app_theme.dart';

const _timeSlots = ['8:00 AM', '10:00 AM', '12:00 PM', '2:00 PM', '4:00 PM', '6:00 PM', '8:00 PM', 'ASAP'];
const _mealSlots = ['Breakfast', 'Lunch', 'Dinner'];

class SelectDateTimeScreen extends ConsumerStatefulWidget {
  const SelectDateTimeScreen({super.key});

  @override
  ConsumerState<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends ConsumerState<SelectDateTimeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedSlot;
  int _people = 2;

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingFlowProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Date & Time')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookingProgressBar(step: 2, total: 7),
            const SizedBox(height: 16),
            Text('Meal', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _mealSlots
                  .map((m) => CategoryChip(
                        label: m,
                        selected: draft.mealSlot == m,
                        onTap: () => ref.read(bookingFlowProvider.notifier).setMealSlot(m),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('Select Date', style: AppTextStyles.h3),
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(border: Border.all(color: context.surfaceColors.divider), borderRadius: BorderRadius.circular(16)),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selected, focused) => setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                }),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(color: AppColors.secondaryOrangeLight, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                ),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              ),
            ),
            const SizedBox(height: 20),
            Text('Select Time', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots
                  .map((t) => CategoryChip(label: t, selected: _selectedSlot == t, onTap: () => setState(() => _selectedSlot = t)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('Number of people', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _people > 1 ? () => setState(() => _people--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_people', style: AppTextStyles.h2),
                IconButton(onPressed: () => setState(() => _people++), icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Continue',
              onPressed: _selectedSlot == null
                  ? null
                  : () {
                      ref.read(bookingFlowProvider.notifier).setDateTime(_selectedDay, _selectedSlot!);
                      ref.read(bookingFlowProvider.notifier).setPeopleCount(_people);
                      context.pushNamed('chooseMenu');
                    },
            ),
          ],
        ),
      ),
    );
  }
}
