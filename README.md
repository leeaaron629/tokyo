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

```json
[
    {
        "createdDate": "2020-05-25T15:16:18Z",
        "exerciseId": "d3a066e6-a403-41f1-9612-033ee5c532aa",
        "exerciseName": "Bench",
        "exerciseRecId": "4cacc859-bb69-423f-9470-3028ab074ca8",
        "sets": [
            {
                "exerciseSetId": "243fdc4d-5b3b-4d13-adb8-bb80cdf214dc",
                "reps": 5,
                "weight": 95
            },
            {
                "exerciseSetId": "704c2778-be60-4fdd-85ed-18fe22338fcd",
                "reps": 5,
                "weight": 115
            },
            {
                "exerciseSetId": "d3aa8c65-60e6-47e8-9990-57e32e274d7d",
                "reps": 10,
                "weight": 135
            }
        ],
        "userId": "@husky",
        "workoutId": "361a2ad1-25ce-4448-ab48-28a034c1ad09"
    }
]
```  

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

