import json
import os
import time

class TimerManager:
    def __init__(self):
        self.state_file = "timer_data.json"
        self.should_resume = False
        self.load_state()

    def load_state(self):
        if os.path.exists(self.state_file):
            with open(self.state_file, 'r') as f:
                state = json.load(f)
                self.running = state.get("running", False)
                self.start_time = state.get("start_time", None)
                self.elapsed = state.get("elapsed", 0)
                self.project = state.get("project", "")
                self.should_resume = state.get("should_resume", False)
        else:
            self.running = False
            self.start_time = None
            self.elapsed = 0
            self.project = ""
            self.should_resume = False

    def save_state(self):
        state = {
            "running": self.running,
            "start_time": self.start_time,
            "elapsed": self.elapsed,
            "project": self.project,
            "should_resume": self.should_resume
        }
        with open(self.state_file, 'w') as f:
            json.dump(state, f)

    def start_timer(self, project_name):
        self.running = True
        self.start_time = time.time()
        self.project = project_name
        self.should_resume = True
        self.save_state()

    def pause_timer(self):
        if self.running:
            elapsed = time.time() - self.start_time
            self.elapsed += elapsed
            self.running = False
            self.start_time = None
            self.save_state()

    def resume_timer(self):
        if not self.running:
            self.start_time = time.time()
            self.running = True
            self.save_state()

    def stop_timer(self):
        if self.running:
            elapsed = time.time() - self.start_time
            self.elapsed += elapsed
            self.running = False
            self.start_time = None
            self.save_state()
        return self.elapsed

    def get_elapsed(self):
        if self.running:
            return self.elapsed + (time.time() - self.start_time)
        return self.elapsed

    def handle_background_suspend(self):
        if self.running:
            self.should_resume = True
            self.pause_timer()

    def handle_foreground_resume(self):
        self.load_state()
        if self.should_resume:
            self.resume_timer()
            self.should_resume = False
