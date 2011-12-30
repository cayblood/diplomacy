Given /^the following board:$/ do |table|
  @provinces = {}
  table.hashes.each do |row_hash|
    @provinces[row_hash['province']] = Province.new(row_hash)
  end
end

Given /^there are the following units:$/ do |string|
  pending # express the regexp above with the code you wish you had
end

When /^the following orders are resolved:$/ do |string|
  pending # express the regexp above with the code you wish you had
end

Then /^the order resolution report should be:$/ do |string|
  pending # express the regexp above with the code you wish you had
end

Then /^there should be the following units:$/ do |string|
  pending # express the regexp above with the code you wish you had
end