# Come Follow Me - Study Journal

This app uses a SQLite database to record goals and notes for each lesson from the 2019 Come Follow Me curriculum. Deep links to Gospel Library are included for each lesson.

When the app initializes, the database is seeded in the app delegate using a simple database that contains each lesson Title, and it's start and end date in presentational format. 

To simplify the app, it uses CoreData to update Lesson entities rather than another SQLite wrapper like GRDB. 
