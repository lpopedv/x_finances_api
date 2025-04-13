[
  otp_app: :core,
  map_node: fn %{schema_module: schema_module} = node ->
    if String.contains?(Atom.to_string(schema_module), "Core.Schemas") do
      node
    else
      nil
    end
  end
]
