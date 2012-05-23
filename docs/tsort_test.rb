require "tsort"

class Hash
 include TSort
 alias tsort_each_node each_key
 def tsort_each_child(node, &block)
   yield(fetch(node)) unless fetch(node).nil?
 end
end

units = {
  :gf => :ga,
  :ga => :ra,
  :ra => nil
}

units.each_strongly_connected_component do |c|
  p c
end

units = {
  "Hol" => "Bel",
  "Bel" => "Nth", 
  "Nth" => "Hol"
}

units.each_strongly_connected_component do |c|
  p c
end
