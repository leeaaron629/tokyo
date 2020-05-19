# Tokyo

RESTful APIs for Exercise Records

## TODO

- Create unit tests for exercise record service

## Endpoints

**GET - /users/{user_id}/exercise-records/**

Fetch a list of exercise records for the given user

Params:
  - fromCreated 
  - toCreated
  - fromCompleted
  - toCompleted

**GET - /users/{user_id}/exercise-records/{ex_rec_id}**

Fetch exercise records by user and exercise record Id.

**POST - /users/{user_id}/exercise-records/**

Creates an exercise record for the given user

```json
{
  "workoutId": "361a2ad1-25ce-4448-ab48-28a034c1ad09",
  "exerciseName": "Squat",
  "sets": [
    {"weight": 95, "reps": 5},
    {"weight": 115, "reps": 5},
    {"weight": 135, "reps": 10}
  ],
  "createdDate": "2019-11-02T15:16:18.382Z"
}
```

**PUT - /users/{user_id}/exercise-records/{ex_rec_id}**

```json
{
  "workoutId": "361a2ad1-25ce-4448-ab48-28a034c1ad09",
  "exerciseName": "Bench",
  "sets": [
    {"weight": 95, "reps": 5},
    {"weight": 115, "reps": 5},
    {"weight": 135, "reps": 10},
    {"weight": 155, "reps": 8},
    {"weight": 175, "reps": 6}
  ],
  "createdDate": "2019-11-02T15:16:18.382Z"
}
```

Saves the exercise record for the given user

**DELETE - /users/{user_id}/exercise-records/{ex_rec_id}**

Removes the exercise record for the given user

