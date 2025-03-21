[
  otp_app: :x_finances,
  map_node: fn %{schema_module: schema_module} = node ->
    module_str = Atom.to_string(schema_module)

    if String.contains?(module_str, "XFinances.Categories") or
         String.contains?(module_str, "XFinances.Transactions") do
      node
    else
      nil
    end
  end
]
