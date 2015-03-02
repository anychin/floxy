# By default Statesman stores transition history in memory only.
# It can be persisted by configuring Statesman to use a different adapter.
# For example, ActiveRecord within Rails:
Statesman.configure do
  storage_adapter(Statesman::Adapters::ActiveRecord)
end
