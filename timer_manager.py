import json
import os
import time

class TimerManager:
    def __init__(self, data_file="timer_data.json"):
        self.data_file = data_file
        self.running = False
        self.start_time = None
        self.elapsed = 0
        self.load_state()

    def load_state(self):
        if os.path.exists(self.data_file):
            with open(self.data_file, 'r') as f:
                state = json.load(f)
            self.running = state.get('running', False)
            self.start_time = state.get('start_time', None)
            self.elapsed = state.get('elapsed', 0)
        else:
            self.running = False
            self.start_time = None
            self.elapsed = 0

    def save_state(self):
        state = {
            'running': self.running,
            'start_time': self.start_time,
            'elapsed': self.elapsed
        }
        with open(self.data_file, 'w') as f:
            json.dump(state, f)

    def start(self):
        self.running = True
        self.start_time = time.time()
        self.save_state()

    def pause(self):
        if self.running:
            self.elapsed += time.time() - self.start_time
            self.running = False
            self.start_time = None
            self.save_state()

    def stop(self):
        if self.running:
            self.elapsed += time.time() - self.start_time
            self.running = False
            self.start_time = None
            self.save_state()

    def get_elapsed(self):
        if self.running:
            return self.elapsed + (time.time() - self.start_time)
        return self.elapsed
