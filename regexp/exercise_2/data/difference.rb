diffs = {}

File.open('weather.dat').each do |line|
  /^\s*(\d+)\D+(\d+\.?\d+)\D+(\d+\.?\d+)\D/ =~ line
  diffs[$1] = $2.to_i - $3.to_i if $1 && $2 && $3
end

day, spread = diffs.sort_by{ |day, spread| spread }.first
puts "The smallest spread of #{spread} happened on day #{day}"