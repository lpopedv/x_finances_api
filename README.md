# XFinances API 🚀

**⚠️ Note: This project is currently under active development.**

XFinances is an open-source financial control system built with Elixir. This repository contains the API component of the system, which provides endpoints for managing your finances. 💰

---

## Overview

The API offers endpoints for:

- **Users**: Perform CRUD operations for user management. 👤
- **Categories**: Manage your financial categories. 🗂️
- **Transactions**: Record and track your financial transactions. 💸

---

## Future Enhancements

- Comprehensive financial reports 📊  
- Integration with cryptocurrency monitoring systems 🔗  
- Automated trading bot for executing trading strategies 🤖  
- Payment reminders and notifications ⏰  

---

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/lpopedv/x_finances_api.git
   cd x_finances_api
   ```

2. **Install dependencies:**

```bash
mix deps.get
```

3. **Start the PostgreSQL Docker container:**

```bash
docker compose up -d
```

4. **Set up the database:**

```bash
mix ecto.setup
```

5. Start the API server:

```bash
mix phx.server
```
