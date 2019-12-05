# Tokyo

RESTful APIs for Exercise Records

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
  "exercise_name": "Squat",
  "sets": [
    {"weight": 95, "reps": 5},
    {"weight": 115, "reps": 5},
    {"weight": 135, "reps": 10}
  ],
  "created_date": "2019-11-02T15:16:18.382Z",
  "completed_date": "2019-11-02T15:16:18.382Z"
}
```

**PUT - /users/{user_id}/exercise-records/{ex_rec_id}**

```json
{
  "exercise_name": "Bench",
  "sets": [
    {"weight": 95, "reps": 5},
    {"weight": 115, "reps": 5},
    {"weight": 135, "reps": 10},
    {"weight": 155, "reps": 8},
    {"weight": 175, "reps": 6}
  ],
  "created_date": "2019-11-02T15:16:18.382Z",
  "completed_date": "2019-11-02T15:18:26.079Z"
}
```

Saves the exercise record for the given user

**DELETE - /users/{user_id}/exercise-records/{ex_rec_id}**

Removes the exercise record for the given user

