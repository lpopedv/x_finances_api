defmodule Core.DataCase do
  @moduledoc """
  ...
  """
  use ExUnit.CaseTemplate

  alias Core.Repo
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias Core.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Core.DataCase
    end
  end

  setup tags do
    Core.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  @spec setup_sandbox(Keyword.t()) :: :ok
  def setup_sandbox(tags) do
    pid = Sandbox.start_owner!(Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.
  """
  @spec errors_on(Ecto.Changeset.t()) :: %{optional(atom()) => [String.t()]}
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _data, key ->
        opts
        |> Keyword.get(String.to_existing_atom(key), key)
        |> to_string()
      end)
    end)
  end
end
