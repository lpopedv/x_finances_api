defmodule XFinancesWeb.TransactionsController do
  use XFinancesWeb, :controller

  alias XFinances.Transactions
  alias XFinances.Transactions.Transaction
  alias XFinancesWeb.FallbackController

  action_fallback FallbackController

  def index(conn, _params) do
    transactions = Transactions.list()

    conn
    |> put_status(:ok)
    |> render(:index, transactions: transactions)
  end

  def create(conn, params) do
    with {:ok, %Transaction{} = transaction} <- Transactions.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, transaction: transaction)
    end
  end

  def update(conn, params) do
    with {:ok, %Transaction{} = transaction} <- Transactions.update(params) do
      conn
      |> put_status(:ok)
      |> render(:update, transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Transaction{} = transaction} <- Transactions.show(id) do
      conn
      |> put_status(:ok)
      |> render(:show, %{transaction: transaction})
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Transaction{} = transaction} <- Transactions.delete(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, %{transaction: transaction})
    end
  end
end
