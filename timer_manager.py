import json
import os
import time

DATA_FILE = os.path.join(os.path.dirname(__file__), 'data', 'timer.json')

class TimerManager:
    def __init__(self):
        self.load_data()

    def load_data(self):
        if not os.path.exists(DATA_FILE):
            self.data = {
                'entries': [],
                'current_timer': None,
                'should_resume': False
            }
        else:
            with open(DATA_FILE, 'r') as f:
                self.data = json.load(f)

    def save_data(self):
        os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
        with open(DATA_FILE, 'w') as f:
            json.dump(self.data, f)

    def start_timer(self, project_name):
        self.data['current_timer'] = {
            'project': project_name,
            'start_time': time.time(),
            'duration': 0,
            'notes': ''
        }
        self.data['should_resume'] = False
        self.save_data()

    def pause_timer(self):
        if self.data['current_timer']:
            self.data['current_timer']['duration'] = time.time() - self.data['current_timer']['start_time']
            self.data['current_timer']['start_time'] = None
            self.data['should_resume'] = True
            self.save_data()

    def stop_timer(self):
        if self.data['current_timer']:
            if self.data['current_timer']['start_time']:
                self.data['current_timer']['duration'] = time.time() - self.data['current_timer']['start_time']
            entry = {
                'id': len(self.data['entries']) + 1,
                'project': self.data['current_timer']['project'],
                'date': time.strftime('%Y-%m-%d'),
                'startTime': self.data['current_timer']['start_time'],
                'endTime': time.time(),
                'duration': self.data['current_timer']['duration'],
                'notes': self.data['current_timer'].get('notes', '')
            }
            self.data['entries'].append(entry)
            self.data['current_timer'] = None
            self.data['should_resume'] = False
            self.save_data()
            return entry

    def get_timer_status(self):
        if self.data['current_timer']:
            if self.data['current_timer']['start_time']:
                current_duration = time.time() - self.data['current_timer']['start_time']
                total_duration = self.data['current_timer']['duration'] + current_duration
                return {
                    'status': 'running',
                    'project': self.data['current_timer']['project'],
                    'duration': total_duration,
                    'notes': self.data['current_timer'].get('notes', '')
                }
            else:
                return {
                    'status': 'paused',
                    'project': self.data['current_timer']['project'],
                    'duration': self.data['current_timer']['duration'],
                    'notes': self.data['current_timer'].get('notes', '')
                }
        return {'status': 'stopped'}

    def get_entries(self):
        return self.data['entries']
