
# <img src="https://github.com/user-attachments/assets/85e03ff9-12e0-4f41-89d1-4cff3648eda6" width="30" alt="ImPower Icon"/> ImPowerX

**ImPowerX** is an Xcode Source Editor Extension that enhances your Swift coding workflow by providing powerful import statement tools. With just a few clicks, you can:

- 📦 **Move a new import to the top** of the file (just below existing import lines)
- 🧹 **Sort all import statements** by length (longest to shortest), removing duplicates

This saves you time, improves code consistency, and keeps your imports clean and readable.

---

## ✨ Features

- 📌 **Move Import to Top:** Automatically places the import at the correct location, maintaining style and order.
- 🔡 **Sort Imports:** Removes duplicates and sorts all import statements from longest to shortest.

---

## 🎥 Demo

### ✅ Move Import to Top

This feature detects a new import statement and moves it directly beneath the last existing import.

![Move Import Demo](https://github.com/user-attachments/assets/478672cf-3415-495d-b077-8c5a7132dcad)


---

### 🔃 Sort Imports

Sorts all imports by length (longest to shortest), and removes any duplicates.

![Sort Imports Demo](https://github.com/user-attachments/assets/60a37dd5-f973-458a-813e-ad3837ca612a)

> _💡 Tip: Keep these clean-ups handy on large files with lots of dependencies!_

---

## 🛠 Usage

1. Open a Swift file in Xcode.
2. Select the import statement you just added.
3. From the menu bar, go to: Editor > ImPowerX > Move Import to Top
4. Or to sort all import statements: Editor > ImPowerX > Sort Imports

## 🚀 Installation

### Step 1: Download the App

Head to the [**Releases**](https://github.com/jatinmishra/ImPower/releases) section and download the latest `ImPower.app`.

### Step 2: Move to Applications

Move the downloaded `ImPower.app` to your `/Applications` folder (or any folder you prefer).

### Step 3: Run the App Once

Double-click to run `ImPower.app`. This is necessary to register the extension with the system.

### Step 4: Enable the Extension

Go to: System Settings > Privacy & Security > Extensions > Xcode Source Editor > Enable **ImPowerX** in the list.

---

## 🔮 Future Improvements

Here are some enhancements planned for future versions:

- 🧭 **Customizable Sorting Logic**  
  - Alphabetical sorting (A-Z / Z-A)
  - Length-based (shortest to longest)
  - Grouped imports (e.g., `Foundation`, third-party, local modules)

- 🚦 **On Save Automation**  
Automatically apply sorting or cleanup when a file is saved.


---

## 💬 Feedback & Contributions

Have suggestions or found a bug? [Open an issue](https://github.com/jatinmishra/impower/issues) or submit a pull request!

---

## 📄 License

MIT License.

---

## 🙌 Credits

Created by [Jatin Mishra](https://github.com/jatinmishra)  
Inspired by real developer needs to streamline Swift imports in Xcode.

