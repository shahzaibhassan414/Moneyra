# Moneyra - AI Personal Finance Agent

Moneyra is an intelligent personal finance application designed to help users manage their money automatically. Unlike traditional finance apps that just display charts, Moneyra leverages an AI agent to analyze, suggest, and act on your financial data.

## 🎯 Goal
Build an app where an AI agent proactively helps users manage their finances instead of just showing screens. The agent analyzes spending habits, suggests improvements, and acts as a financial co-pilot.

## 🚀 Key Features

### 1. Expense Tracking & Categorization
- **Smart Entry:** Add transactions manually, via bank API, or CSV upload.
- **AI Categorization:** Automatically categorizes transactions (e.g., Food, Rent, Entertainment).
- **Pattern Detection:** Identifies spending trends like "You spent 30% more on coffee this month."

### 2. Budgeting & Alerts
- **AI-Driven Budgets:** Suggests monthly budgets based on historical spending.
- **Proactive Reminders:** Notifies you if spending is exceeding the budget.
- **Corrective Actions:** Suggests ways to save, like using cashback options.

### 3. Savings Recommendations
- **Trend Prediction:** AI predicts possible savings based on current trends.
- **Investment Suggestions:** Suggests moving idle money to high-interest savings or investments.
- **Scenario Simulation:** "What-if" analysis (e.g., "If you reduce dining out by 50%, you'll save $200").

### 4. Forecasting & Insights
- **Cash Flow Prediction:** Visualizes future financial health.
- **Irregularity Highlights:** Flags unusual or unexpected transactions.
- **Automated Reports:** Generates weekly, monthly, and yearly insights automatically.

### 5. On-Device / Offline AI (Optional)
- **Privacy First:** Local AI reasoning for privacy-sensitive data.
- **Offline Analysis:** Analyze spending trends even without an internet connection.

## 🛠 Tech Stack

- **Frontend:** [Flutter](https://flutter.dev/)
- **Local Database:** Hive or SQLite
- **AI / Agent Logic:**
  - **OpenAI API:** For complex reasoning, categorization, and budgeting suggestions.
  - **TensorFlow Lite:** For on-device offline categorization and trend analysis.
- **Integrations:** Optional Bank API integration (e.g., Plaid) for automatic transaction imports.

---

## Getting Started

This project is a Flutter application. 

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio / VS Code

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/moneyra.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/).
