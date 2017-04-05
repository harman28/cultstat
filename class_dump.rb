#!/usr/bin/env ruby
require 'httparty'
require 'json'

TIME = Time.now.to_i

# Script runs every 10 minutes, so this ensures the same
# file is used for 5 hours' worth of results
LOG_FILE = "/home/harman/cult/logs/cult_classes_#{TIME/18000}.csv"

# Cult has 7 centers in all
(1..7).each do |center|
  response = HTTParty.get("https://api.cultfit.in/v1/classes?center=#{center}")

  open(LOG_FILE, 'a') do |f|
    JSON.parse(response.body)['classes'].each do |klass|
      arr=[
        TIME,
        klass['id'],
        klass['date'],
        klass['centerID'],
        klass['workoutID'],
        klass['cultAppAvailableSeats'],
        klass['startTime'],
        klass['endTime'],
        klass['formattedStartTime'],
        klass['formattedEndTime'],
        klass['isActive'],
        klass['bookingNumber'],
        klass['version']
      ]

      f.puts arr.join(',')
    end
  end
end
