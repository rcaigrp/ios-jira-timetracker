import json
import os
import time

class TimerManager:
    def __init__(self, state_file="timer_data.json"):
        self.state_file = state_file
        self.running = False
        self.start_time = None
        self.elapsed = 0
        self.should_resume = False
        self.project_name = None
        self.load_state()

    def load_state(self):
        if os.path.exists(self.state_file):
            with open(self.state_file, 'r') as f:
                data = json.load(f)
                self.running = data.get('running', False)
                self.start_time = data.get('start_time')
                self.elapsed = data.get('elapsed', 0)
                self.should_resume = data.get('should_resume', False)
                self.project_name = data.get('project_name')
        else:
            self.running = False
            self.start_time = None
            self.elapsed = 0
            self.should_resume = False
            self.project_name = None

    def save_state(self):
        with open(self.state_file, 'w') as f:
            json.dump({
                'running': self.running,
                'start_time': self.start_time,
                'elapsed': self.elapsed,
                'should_resume': self.should_resume,
                'project_name': self.project_name
            }, f)

    def start(self, project_name):
        self.running = True
        self.start_time = time.time()
        self.elapsed = 0
        self.should_resume = False
        self.project_name = project_name
        self.save_state()
        return {'status': 'running', 'project': project_name}

    def pause(self):
        if self.running:
            current_time = time.time()
            self.elapsed += current_time - self.start_time
            self.running = False
            self.start_time = None
            self.should_resume = True
            self.save_state()
            return {'status': 'paused', 'elapsed': self.elapsed}
        return {'status': 'stopped'}

    def resume(self):
        if self.should_resume:
            self.running = True
            self.start_time = time.time()
            self.should_resume = False
            self.save_state()
            return {'status': 'running'}
        return {'status': 'stopped'}

    def stop(self):
        if self.running:
            current_time = time.time()
            self.elapsed += current_time - self.start_time
            self.running = False
            self.start_time = None
            self.should_resume = False
            self.save_state()
            return {'status': 'stopped', 'elapsed': self.elapsed}
        return {'status': 'stopped'}
