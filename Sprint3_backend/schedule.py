class Schedule:
    def __init__(self):
        self.schedule = {
            'Monday': [None] * 24,
            'Tuesday': [None] * 24,
            'Wednesday': [None] * 24,
            'Thursday': [None] * 24,
            'Friday': [None] * 24,
            'Saturday': [None] * 24
        }

    def set_event(self, day, start_time, end_time, event):
        if start_time.hour < 7 or end_time.hour > 19:
            raise ValueError('Events can only be scheduled between 7 am and 7 pm.')

        start_index = start_time.hour - 7
        end_index = end_time.hour - 7

        if start_time.minute >= 30:
            start_index += 0.5
        if end_time.minute > 0:
            end_index += 0.5

        start_index = int(start_index * 2)
        end_index = int(end_index * 2)

        start_time_24hr = start_time.replace(hour=start_time.hour + 7)
        end_time_24hr = end_time.replace(hour=end_time.hour + 7)

        day_schedule = self.schedule.get(day)
        if not day_schedule:
            raise ValueError('Invalid day.')

        if any(day_schedule[start_index:end_index]):
            raise ValueError('There is already an event scheduled in the given time slot.')

        day_schedule[start_index:end_index] = [(start_time_24hr, end_time_24hr, event)] * (end_index - start_index)

    def get_event(self, day, time):
        day_schedule = self.schedule.get(day)
        if not day_schedule:
            raise ValueError('Invalid day.')

        index = int((time.hour - 7) * 2)
        if time.minute >= 30:
            index += 1

        event = day_schedule[index]
        if event:
            start_time_24hr, end_time_24hr, event_description = event
            return start_time_24hr, end_time_24hr, event_description
        else:
            return None

    def remove_event(self, day, time):
        day_schedule = self.schedule.get(day)
        if not day_schedule:
            raise ValueError('Invalid day.')

        index = int((time.hour - 7) * 2)
        if time.minute >= 30:
            index += 1

        if not day_schedule[index]:
            raise ValueError('No event scheduled at the given time.')

        day_schedule[index] = None

    def print_schedule(self):
        for day, day_schedule in self.schedule.items():
            print(day)
            for index, event in enumerate(day_schedule):
                if event:
                    start_time_24hr, end_time_24hr, event_description = event
                    start_time = start_time_24hr.replace(hour=start_time_24hr.hour - 7)
                    end_time = end_time_24hr.replace(hour=end_time_24hr.hour - 7)
                    print(f'{start_time.strftime("%H:%M")} - {end_time.strftime("%H:%M")}: {event_description}')
                else:
                    start_time = (index // 2) + 7
                    end_time = start_time + 0.5
                    print(f'{start_time:02.0f}:{"00" if index % 2 == 0 else "30"} - {end_time:02.0f}:{"00" if index % 2 == 0 else "30"}: (Available)')
            print()
