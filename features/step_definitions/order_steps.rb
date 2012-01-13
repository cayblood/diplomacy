Given /^the following board:$/ do |table|
  @provinces = {}
  table.hashes.each do |row_hash|
    @provinces[row_hash['province']] = Province.new(row_hash)
  end
end

Given /^there are the following units:$/ do |state_text|
  @board = Board.new(state_text)
end

When /^the following orders are resolved:$/ do |orders|
  @report = @board.resolve_orders(orders)
end

Then /^the order resolution report should be:$/ do |expected_report|
  @report.should eql(expected_report)
end

Then /^there should be the following units:$/ do |expected_report_text|
  @board.unit_report.should eql(expected_report_text)
end