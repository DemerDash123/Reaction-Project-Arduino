# ⚡ Cyberpunk Trick Reaction Game

![Arduino](https://img.shields.io/badge/Arduino-00979D?style=for-the-badge&logo=arduino&logoColor=white)
![Processing](https://img.shields.io/badge/Processing-006699?style=for-the-badge&logo=processingfoundation&logoColor=white)
![Language](https://img.shields.io/badge/C++-Arduino-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

A cyberpunk-style **reaction time game** built using **Arduino + Processing**.

The player must react **ONLY when GREEN light AND sound happen together**.  
Fake signals (tricks) attempt to fool the player before the real signal appears.

---

# 🎥 Demo

> Add your GIF or video here:

Or upload a short gameplay video.

---

# 🎮 Game Concept

### 🔵 Waiting Mode
Blue LED indicates system is ready.

### 🎭 Fake Signals
- 🔊 Sound only
- 💡 Green light only

### ✅ Real Signal
- 💡 Green light + 🔊 Sound together

### ⏱ Result
- Reaction time measured in milliseconds
- Rank displayed
- Particle explosion effect
- Futuristic performance bar

---

# 🧠 System Architecture

## 🔹 Arduino Responsibilities

- Detect hand using ultrasonic sensor
- Generate 2–5 fake signals
- Force real signal after max tricks
- Measure reaction time
- Send serial messages to Processing

### Serial Communication Protocol

| Message | Meaning |
|----------|----------|
| `GO` | Real signal started |
| `FAIL` | False start |
| `RESULT:xxx` | Reaction time in ms |

---

## 🔹 Processing Responsibilities

- Read serial data
- Render cyberpunk UI
- Manage game states:
  - WAIT
  - FAIL
  - RESULT
- Display rank
- Generate particle system
- Show animated performance bar
- Neon grid animation
- Scanline + vignette effects

---

# 🛠 Hardware Requirements

- Arduino (Uno / Nano / etc.)
- HC-SR04 Ultrasonic Sensor
- RGB LED
- Buzzer
- Breadboard
- Jumper wires

---

# 🔌 Pin Configuration

| Component | Pin |
|-----------|------|
| Trig      | 2 |
| Echo      | 3 |
| Red LED   | 9 |
| Green LED | 10 |
| Blue LED  | 11 |
| Buzzer    | 6 |

---

# 📁 Project Structure


---

# 🚀 Installation Guide

## 1️⃣ Arduino Setup

1. Open Arduino IDE
2. Select board
3. Select correct COM port
4. Upload `reaction_game.ino`

---

## 2️⃣ Processing Setup

1. Install Processing
2. Ensure Serial library is installed
3. Update this line:

```java
String portName = "COM7";  // Change to your port
```

#🏆 Ranking System

	

| Reaction Time | Rank |
|-----------|------|
|< 300 ms	  | LEGENDARY |
| < 500 ms	| GOOD |
| < 700 ms	   | AVERAGE |
| > 700 ms	  | TOO SLOW |

