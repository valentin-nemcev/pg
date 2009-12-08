#!/usr/bin/env /Users/valentine/Work/Polit-gramota/pg/script/runner

(1..10).each do |i|
  next(5) if i==2
  puts i
end