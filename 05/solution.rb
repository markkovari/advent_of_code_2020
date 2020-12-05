#!/usr/bin/env ruby


file = File.open("input.txt")

def get_value_of_ticket(text)
    
    ship_length=128
    dictionary = { 
        "F" => 0,
        "B" => 1,
        "R" => 1,
        "L" => 0
    }
    divides = Math.log( ship_length,2 )

    rows = text[0..divides-1]
    columns = text[divides..text.length]

    row_value = rows.split("").reverse().each_with_index
    .map { |x,i| dictionary[x] * 2 ** i }.reduce(0, :+)

    column_value = columns.split("").reverse().each_with_index
    .map { |x,i| dictionary[x] * 2 ** i }.reduce(0, :+)

    return row_value * 8 + column_value
end

ticket_values = File.read("input.txt").split.map{|ticket| get_value_of_ticket(ticket)}

ticket_values.sort.each_with_index do |item, index|
    if !ticket_values.include?(item - 1 ) || !ticket_values.include?(item  +1  )
        puts "current_index: #{item}"
    end
  end

