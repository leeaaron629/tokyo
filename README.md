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

**POST - /users/{user_id}/exercise-records/**

Creates an exercise record for the given user

Body:

```json
{
  "exerciseId": "bb142db7-b60a-466b-b12e-1fbd2bf83858",
  "userId": "leeaaron326",
  "sets": [
    {"weight": 95, "reps": 5},
    {"weight": 115, "reps": 5},
    {"weight": 135, "reps": 10}
  ],
  "createdDate": "2019-11-02T15:16:18.382Z",
  "completedDate": "2019-11-02T15:16:18.382Z"
}
```

**PUT - /users/{user_id}/exercise-records/{ex_rec_id}**

```json
{
  "exerciseId": "bb142db7-b60a-466b-b12e-1fbd2bf83858",
  "userId": "leeaaron326",
  "sets": [
    {"weight": 95, "reps": 5},
    {"weight": 115, "reps": 5},
    {"weight": 135, "reps": 10},
    {"weight": 155, "reps": 8},
    {"weight": 175, "reps": 6}
  ],
  "createdDate": "2019-11-02T15:16:18.382Z",
  "completedDate": "2019-11-02T15:18:26.079Z"
}
```

Saves the exercise record for the given user

**DELETE - /users/{user_id}/exercise-records/{ex_rec_id}**

Removes the exercise record for the given user

