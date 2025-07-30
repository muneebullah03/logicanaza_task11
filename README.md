# 🔊 Multilingual Text-to-Speech Flutter App

This is a simple Flutter app developed as a trial task for the Flutter Developer position at **Logicanza**. The app demonstrates multilingual **Text-to-Speech (TTS)** functionality using the [`flutter_tts`](https://pub.dev/packages/flutter_tts) package.

---

Watch a demo video Here 
https://drive.google.com/file/d/19oLMaN3k5-JPoemfEYGXwfbkaiyrEapu/view?usp=drive_link

## 📱 Features

- Dropdown to select a language (English, French, Spanish, German, etc.)
- TextField to enter a custom sentence
- "Play" button to speak the sentence aloud in the selected language
- Automatic toggling between male and female voices (if supported)
- Proper error handling for unsupported languages or voices
- Simple, functional, and clean user interface

---

## 🧪 Example Flow

1. User selects **French** from the dropdown.
2. Enters: `Bonjour, comment ça va ?`
3. Taps the **Play** button.
4. App reads the sentence aloud using a French voice.
5. On next tap of Play, the app attempts to switch to a different voice (if supported).

---

## 🛠️ Getting Started

### 🔧 Prerequisites
- Flutter SDK installed
- Android Studio, VS Code, or any IDE of your choice
- A device/emulator with TTS support

### 🧰 Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/muneebullah03/multilingual-tts-flutter.git
   cd multilingual-tts-flutter
