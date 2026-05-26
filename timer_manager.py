import json
import time
import os

class TimerManager:
    def __init__(self, storage_path="timer_data.json"):
        self.storage_path = storage_path
        self.state = self.load_state()
        self.running = self.state.get("running", False)
        self.start_time = self.state.get("start_time", None)
        self.paused_start = self.state.get("paused_start", None)
        self.elapsed = self.state.get("elapsed", 0)
        self.project_name = self.state.get("project_name", "")

    def load_state(self):
        if os.path.exists(self.storage_path):
            with open(self.storage_path, 'r') as f:
                return json.load(f)
        return {"elapsed": 0, "project_name": "", "running": False, "start_time": None, "paused_start": None}

    def save_state(self):
        with open(self.storage_path, 'w') as f:
            json.dump({
                "elapsed": self.elapsed,
                "project_name": self.project_name,
                "running": self.running,
                "start_time": self.start_time,
                "paused_start": self.paused_start
            }, f)

    def start(self, project_name):
        self.project_name = project_name
        self.running = True
        self.start_time = time.time()
        self.paused_start = None
        self.save_state()

    def pause(self):
        if self.running and self.start_time:
            self.paused_start = time.time()
            self.elapsed += self.paused_start - self.start_time
            self.running = False
            self.save_state()

    def resume(self):
        if not self.running and self.paused_start:
            self.running = True
            self.start_time = time.time()
            self.paused_start = None
            self.save_state()

    def stop(self):
        if self.running:
            self.pause()
        self.running = False
        self.start_time = None
        self.paused_start = None
        self.save_state()

    def go_to_background(self):
        if self.running:
            self.pause()

    def go_to_foreground(self):
        if self.running:
            self.resume()
