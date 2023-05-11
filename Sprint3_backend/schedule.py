class Schedule:
    def __init__(self):
        self.schedule = {
            'Monday': [None] * 24,  # 24 intervals from 7 am to 7 pm
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

        day_schedule = self.schedule.get(day)
        if not day_schedule:
            raise ValueError('Invalid day.')

        if any(day_schedule[start_index:end_index]):
            raise ValueError('There is already an event scheduled in the given time slot.')

        day_schedule[start_index:end_index] = [event] * (end_index - start_index)

    def get_event(self, day, start_time):
        index = start_time.hour - 7
        if start_time.minute >= 30:
            index += 0.5
        index = int(index * 2)

        day_schedule = self.schedule.get(day)
        if not day_schedule:
            raise ValueError('Invalid day.')
        if index < 0 or index >= 24:
            raise ValueError('Invalid start time.')

        return day_schedule[index]

    def remove_event(self, day, start_time):
        index = start_time.hour - 7
        if start_time.minute >= 30:
            index += 0.5
        index = int(index * 2)

        day_schedule = self.schedule.get(day)
        if not day_schedule:
            raise ValueError('Invalid day.')
        if index < 0 or index >= 24:
            raise ValueError('Invalid start time.')

        day_schedule[index] = None

    def print_schedule(self):
        for day, day_schedule in self.schedule.items():
            print(day)
            for i, event in enumerate(day_schedule):
                if event:
                    start_time = f'{i // 2 + 7:02}:{i % 2 * 30:02}'
                    end_time = f'{(i + 1) // 2 + 7:02}:{(i + 1) % 2 * 30:02}'
                    print(f'{start_time} - {end_time}: {event}')
