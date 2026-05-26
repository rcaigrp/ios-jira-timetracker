import json
import os
import time

class TimerManager:
    def __init__(self, data_file='data/timer.json'):
        self.data_file = data_file
        self.state = self.load_state()
        self.entries = self.state.get('entries', [])
        self.is_running = self.state.get('is_running', False)
        self.start_time = self.state.get('start_time', None)
        self.total_elapsed = self.state.get('total_elapsed', 0)
        self.should_resume = self.state.get('should_resume', False)
        self.current_project = self.state.get('current_project', None)

    def load_state(self):
        if os.path.exists(self.data_file):
            with open(self.data_file, 'r') as f:
                return json.load(f)
        return {}

    def save_state(self):
        state = {
            'entries': self.entries,
            'is_running': self.is_running,
            'start_time': self.start_time,
            'total_elapsed': self.total_elapsed,
            'should_resume': self.should_resume,
            'current_project': self.current_project
        }
        os.makedirs(os.path.dirname(self.data_file), exist_ok=True)
        with open(self.data_file, 'w') as f:
            json.dump(state, f)

    def start_timer(self, project_name):
        self.current_project = project_name
        self.is_running = True
        self.start_time = time.time()
        self.should_resume = False
        self.save_state()

    def pause_timer(self):
        if self.is_running:
            current_time = time.time()
            elapsed = current_time - self.start_time
            self.total_elapsed += elapsed
            self.is_running = False
            self.save_state()

    def resume_timer(self):
        if self.should_resume or not self.is_running:
            self.is_running = True
            self.start_time = time.time()
            self.should_resume = False
            self.save_state()

    def stop_timer(self):
        if self.is_running:
            self.pause_timer()
            entry = {
                'project': self.current_project or 'Manual Entry',
                'start_time': self.total_elapsed,
                'duration': self.total_elapsed,
                'notes': ''
            }
            self.entries.append(entry)
            self.total_elapsed = 0
            self.is_running = False
            self.start_time = None
            self.should_resume = False
            self.save_state()
