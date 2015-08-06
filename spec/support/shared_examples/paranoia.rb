shared_examples_for 'a Paranoid model' do

  it { should have_db_column(:deleted_at) } 

  it 'skips adding the deleted_at where clause when unscoped' do
    described_class.unscoped.where_sql.to_s.should_not include("deleted_at")  # to_s to handle nil.
  end

end
