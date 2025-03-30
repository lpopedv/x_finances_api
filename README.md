# XFinances

XFinances is an open-source financial control system built with Elixir, featuring both an API and a dedicated frontend interface.

---

## API

### Overview

The API provides endpoints for managing finances. It currently supports:

- CRUD operations for Users
- CRUD operations for Categories
- CRUD operations for Transactions

### Future Enhancements

- Comprehensive financial reports
- Integration with cryptocurrency monitoring systems
- Trading bot for automated trading strategies
- Payment reminders and notifications

### Installation (API)

1. Clone the repository:

```
   git clone <https://github.com/lpopedv/x_finances_api.git>
```

```
   cd x_finances_api
```

2. Install dependencies:

   ```
   mix deps.get
   ```

2. up postgresql docker container:

   ```
   docker compose up -d
   ```

3. Set up the database:

```
   mix ecto.setup
```

4. Start the API server:

```
   mix phx.server
```
