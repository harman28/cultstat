#!/usr/bin/env ruby
require 'httparty'
require 'json'

TIME = Time.now.to_i

LOG_FILE = "/home/harman/cult/logs/cult_classes_#{TIME/1800}.csv"

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