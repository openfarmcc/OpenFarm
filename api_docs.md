
# GET /api/crops



## Params
```
{
  "query": "mung"
}
```


## Response
```
{
  "crops": [
    {
      "_id": "5426d2c4736d61c6a5310000",
      "name": "mung bean",
      "binomial_name": "optio ad",
      "description": "Rerum praesentium est rem optio.",
      "sun_requirements": "full",
      "sowing_method": "container",
      "spread": 10,
      "days_to_maturity": 16,
      "row_spacing": 18,
      "height": 10
    }
  ]
}
```



# GET /api/crops/5426d2c4736d61c6a53a0000




## Response
```
{
  "crop": {
    "_id": "5426d2c4736d61c6a53a0000",
    "name": "orange Herzog",
    "binomial_name": "inventore consequatur",
    "description": "Sit consequatur non deserunt repellendus ad modi fuga facere.",
    "sun_requirements": "shade",
    "sowing_method": "direct",
    "spread": 13,
    "days_to_maturity": 46,
    "row_spacing": 6,
    "height": 4
  }
}
```



# POST /api/guides



## Params
```
{
  "name": "brocolini in the desert",
  "overview": "something exotic",
  "crop_id": "5426d2c5736d61c6a5b70000"
}
```


## Response
```
{
  "guide": {
    "_id": "5426d2c5736d61c6a5b80000",
    "crop_id": "5426d2c5736d61c6a5b70000",
    "user_id": "5426d2c5736d61c6a5b60000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "brocolini in the desert",
    "overview": "something exotic",
    "featured_image": "https://openfarm.cc/img/page.png"
  }
}
```



# POST /api/guides



## Params
```
{
  "name": "Just 1 pixel.",
  "overview": "A tiny pixel test image.",
  "featured_image": "http://placehold.it/1x1.jpg",
  "crop_id": "5426d2c5736d61c6a5860000"
}
```


## Response
```
{
  "guide": {
    "_id": "5426d2c5736d61c6a5880000",
    "crop_id": "5426d2c5736d61c6a5860000",
    "user_id": "5426d2c5736d61c6a5870000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "Just 1 pixel.",
    "overview": "A tiny pixel test image.",
    "featured_image": "http://s3.amazonaws.com/openfarm-rick/test/media/guides/featured_images/5426d2c5736d61c6a5880000.jpg?1411830469"
  }
}
```




# PUT /api/guides/5426d2c5736d61c6a57c0000



## Params
```
{
  "overview": "updated"
}
```


## Response
```
{
  "guide": {
    "_id": "5426d2c5736d61c6a57c0000",
    "crop_id": "5426d2c5736d61c6a57b0000",
    "user_id": "5426d2c5736d61c6a57a0000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "salmon Collier",
    "overview": "updated",
    "featured_image": "https://openfarm.cc/img/page.png"
  }
}
```



# GET /api/guides/5426d2c5736d61c6a5930000




## Response
```
{
  "guide": {
    "_id": "5426d2c5736d61c6a5930000",
    "crop_id": "5426d2c5736d61c6a5920000",
    "user_id": "5426d2c5736d61c6a5940000",
    "stages": [

    ],
    "requirements": [

    ],
    "name": "plum Braun",
    "overview": "Explicabo enim deleniti accusamus eaque voluptatum culpa est et.",
    "featured_image": "https://openfarm.cc/img/page.png"
  }
}
```









# DELETE /api/token

## Notes
You must be logged in to perform this action. No parameters are required. This is a log out action, essentially.






# POST /api/token

## Notes
Hit this API endpoint to generate an authentication token. Take the token that it returns and insert it as a request header like so: `Authorization: Token token=YOUR_TOKEN_HERE`



## Params
```
{
  "email": "marcellus.strosin@rosenbaum.org",
  "password": "password"
}
```


## Response
```
{
  "token": {
    "expiration": "2014-10-27T15:07:48.626Z",
    "secret": "marcellus.strosin@rosenbaum.org:67fcccce4285380fa0ff141abf98236a"
  }
}
```


