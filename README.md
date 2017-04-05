# CultStat

[Cult](https://www.cultfit.in/) has [a public API](https://api.cultfit.in/v1/classes?center=1), which contains a lot of info that really shouldn't be showing up in a public API.
```json
{
  "classes": [
    {
      "bookingNumber": null,
      "date": "2017-04-05",
      "formattedStartTime": "6:00AM",
      "formattedEndTime": "6:50AM",
      "id": 12537,
      "startTime": "06:00:00",
      "endTime": "06:50:00",
      "workoutID": 4,
      "centerID": 1,
      "isActive": true,
      "cultAppAvailableSeats": 4,
      "version": 0
    },
    {
      "bookingNumber": null,
      "date": "2017-04-05",
      "formattedStartTime": "6:00AM",
      "formattedEndTime": "6:50AM",
      "id": 12538,
      "startTime": "06:00:00",
      "endTime": "06:50:00",
      "workoutID": 5,
      "centerID": 1,
      "isActive": true,
      "cultAppAvailableSeats": 0,
      "version": 0
    },
    ...
  ]
}
```

Nothing too bad, just things like available seats. I thought it might be interesting to analyze some of this data and find out stuff like which classes are popular, when people generally book classes, etc. This is a collection of the scripts to do this.

### Public APIs
- [Classes](https://api.cultfit.in/v1/classes?center=1)
- [Workouts](https://api.cultfit.in/v1/workouts)
- [Centers](https://api.cultfit.in/v1/centers)

Other APIs exist too, which can be hit using a token you get when you sign up. Haven't found a good use for them yet.

### Fetching Data
Right now, `class_dump.rb` just fetches the class availability data, and puts it in a CSV with the timestamp. I'm polling the API as often as possible, so the following line was added to crontab:
```
*/10 * * * * ruby /home/harman/cult/class_dump.rb
```
The CSV will get big quickly (the API returns results for the next three days, and I get exactly 152 rows per call), and I like opening my CSVs in Sublime, so to set a rough limit of 5k rows per CSV, one file is used for every 5 hours (30 requests * 152 rows = 4560). This is done by diving the timestamp by 18000 (300 mins * 60 seconds) and using it in the filename.
Later, all files can be iterated to populate a DB.

The script is running on a remote machine, so I'm fetching the data to local regularly.
```sh
*/15 * * * * rsync --dry-run --recursive --verbose --progress --exclude '.gitignore' harman@<remote_ip>:~/cult/logs/ /Users/harmansingh/workplace/cult/logs
```
Also keeping this aliased to check most recent sync.
```sh
alias cult_status="cd ~/workplace/cult/logs/; ls -1 | tail -1 | xargs tail -1 | cut -c1-10 | xargs date -r; cd - 1>/dev/null"
```

### TODO
- DB population script
- Cool queries

### License
Haven't quite figured this out yet. I'm concerned that Cult might not fully approve of what I'm doing here, so if that's the case, I want to be sure nobody else can use this to gain personally, anyhow. Need to research if a license like this exists. Something like [CC BY-NC-SA 3.0 AU](https://creativecommons.org/licenses/by-nc-sa/3.0/), but software-oriented.

Okay let's go with that for now.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.
